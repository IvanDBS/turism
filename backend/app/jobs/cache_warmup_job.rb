class CacheWarmupJob < ApplicationJob
  queue_as :default
  
  # JIT optimization: warm up frequently accessed data
  def perform
    Rails.logger.info "Starting cache warmup"
    
    # JIT optimization: parallel cache warming
    warmup_tasks = [
      -> { warmup_tours_cache },
      -> { warmup_categories_cache },
      -> { warmup_featured_tours_cache },
      -> { warmup_user_stats_cache }
    ]
    
    warmup_tasks.each do |task|
      begin
        task.call
      rescue => e
        Rails.logger.error "Cache warmup error: #{e.message}"
      end
    end
    
    Rails.logger.info "Cache warmup completed"
  end
  
  private
  
  def warmup_tours_cache
    # JIT optimization: cache popular tours
    popular_tours = Tour.active
                       .order(rating: :desc, created_at: :desc)
                       .limit(100)
    
    popular_tours.each do |tour|
      Rails.cache.write("tour_#{tour.id}", tour, expires_in: 1.hour)
    end
    
    Rails.logger.info "Tours cache warmed up: #{popular_tours.count} tours"
  end
  
  def warmup_categories_cache
    # JIT optimization: cache tour categories
    categories = Tour.distinct.pluck(:category).compact
    
    Rails.cache.write('tour_categories', categories, expires_in: 24.hours)
    
    Rails.logger.info "Categories cache warmed up: #{categories.count} categories"
  end
  
  def warmup_featured_tours_cache
    # JIT optimization: cache featured tours
    featured_tours = Tour.featured.active.limit(20)
    
    Rails.cache.write('featured_tours', featured_tours, expires_in: 2.hours)
    
    Rails.logger.info "Featured tours cache warmed up: #{featured_tours.count} tours"
  end
  
  def warmup_user_stats_cache
    # JIT optimization: cache user statistics
    stats = {
      total_users: User.count,
      total_tours: Tour.count,
      total_bookings: Booking.count,
      active_tours: Tour.active.count
    }
    
    Rails.cache.write('app_stats', stats, expires_in: 1.hour)
    
    Rails.logger.info "User stats cache warmed up"
  end
end
