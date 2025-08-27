class PeriodicObsSyncJob < ApplicationJob
  queue_as :default
  
  # JIT optimization: run every hour
  def perform
    Rails.logger.info "Starting periodic OBS sync"
    
    # JIT optimization: check if sync is needed
    last_sync = Rails.cache.read('last_obs_sync')
    if last_sync && last_sync > 30.minutes.ago
      Rails.logger.info "OBS sync skipped - last sync was #{last_sync}"
      return
    end
    
    # JIT optimization: incremental sync
    sync_options = {
      batch_size: 50,
      page: 1,
      updated_since: last_sync
    }
    
    # Schedule sync job
    ObsSyncJob.perform_later('tours', sync_options)
    
    # Update last sync timestamp
    Rails.cache.write('last_obs_sync', Time.current, expires_in: 1.hour)
    
    Rails.logger.info "Periodic OBS sync scheduled"
  end
end
