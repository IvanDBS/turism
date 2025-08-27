class ObsSyncJob < ApplicationJob
  queue_as :obs_sync
  
  # JIT optimization: retry with exponential backoff
  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  
  def perform(sync_type = 'tours', options = {})
    case sync_type
    when 'tours'
      sync_tours(options)
    when 'categories'
      sync_categories
    when 'all'
      sync_all_data
    else
      raise ArgumentError, "Unknown sync type: #{sync_type}"
    end
  end
  
  private
  
  def sync_tours(options = {})
    Rails.logger.info "Starting OBS tours sync job"
    
    # JIT optimization: batch processing
    batch_size = options[:batch_size] || 100
    page = options[:page] || 1
    
    response = ObsService.get_tours({ 
      page: page, 
      per_page: batch_size,
      **options.except(:batch_size, :page)
    })
    
    if response[:success]
      tours_data = response[:data]['tours'] || []
      synced_count = 0
      
      # JIT optimization: bulk operations
      tours_data.each_slice(50) do |batch|
        batch.each do |tour_data|
          tour = Tour.find_or_initialize_by(obs_id: tour_data['id'])
          tour.assign_attributes(
            title: tour_data['title'],
            description: tour_data['description'],
            price: tour_data['price'],
            duration: tour_data['duration'],
            destination: tour_data['destination'],
            category: tour_data['category'],
            image_url: tour_data['image_url'],
            obs_data: tour_data,
            last_synced_at: Time.current
          )
          
          if tour.save
            synced_count += 1
          end
        end
      end
      
      # JIT optimization: schedule next batch if needed
      if tours_data.count == batch_size
        ObsSyncJob.perform_later('tours', options.merge(page: page + 1))
      end
      
      Rails.logger.info "OBS tours sync completed: #{synced_count} tours synced"
      
      # JIT optimization: cache invalidation
      Rails.cache.delete_matched("tours_*")
      
      {
        success: true,
        synced_count: synced_count,
        total_tours: tours_data.count,
        page: page
      }
    else
      Rails.logger.error "OBS tours sync failed: #{response[:error]}"
      raise StandardError, response[:error]
    end
  end
  
  def sync_categories
    Rails.logger.info "Starting OBS categories sync job"
    
    response = ObsService.get_categories
    
    if response[:success]
      categories = response[:data]['categories'] || []
      
      # JIT optimization: cache categories
      Rails.cache.write('obs_categories', categories, expires_in: 24.hours)
      
      Rails.logger.info "OBS categories sync completed: #{categories.count} categories"
      
      {
        success: true,
        categories_count: categories.count
      }
    else
      Rails.logger.error "OBS categories sync failed: #{response[:error]}"
      raise StandardError, response[:error]
    end
  end
  
  def sync_all_data
    Rails.logger.info "Starting full OBS sync job"
    
    # JIT optimization: parallel processing
    jobs = []
    
    # Sync categories first
    jobs << ObsSyncJob.perform_later('categories')
    
    # Sync tours in batches
    jobs << ObsSyncJob.perform_later('tours', { batch_size: 100, page: 1 })
    
    Rails.logger.info "Full OBS sync jobs scheduled: #{jobs.count} jobs"
    
    {
      success: true,
      jobs_scheduled: jobs.count
    }
  end
end
