# JIT optimization: Automatic scheduling configuration
if Rails.env.production?
  # JIT optimization: schedule periodic tasks
  require 'sidekiq-cron'
  
  # JIT optimization: periodic OBS sync every hour
  Sidekiq::Cron::Job.create(
    name: 'Periodic OBS Sync',
    cron: '0 * * * *', # Every hour
    class: 'PeriodicObsSyncJob'
  )
  
  # JIT optimization: cache warmup every 30 minutes
  Sidekiq::Cron::Job.create(
    name: 'Cache Warmup',
    cron: '*/30 * * * *', # Every 30 minutes
    class: 'CacheWarmupJob'
  )
  
  # JIT optimization: performance monitoring every 5 minutes
  Sidekiq::Cron::Job.create(
    name: 'Performance Monitoring',
    cron: '*/5 * * * *', # Every 5 minutes
    class: 'PerformanceMonitoringJob'
  )
end
