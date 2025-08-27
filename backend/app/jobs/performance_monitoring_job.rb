class PerformanceMonitoringJob < ApplicationJob
  queue_as :default
  
  # JIT optimization: monitor performance metrics
  def perform
    Rails.logger.info "Starting performance monitoring"
    
    # JIT optimization: collect metrics
    metrics = {
      timestamp: Time.current,
      memory_usage: memory_usage,
      database_connections: database_connections,
      cache_stats: cache_stats,
      redis_stats: redis_stats,
      sidekiq_stats: sidekiq_stats
    }
    
    # JIT optimization: store metrics in cache
    Rails.cache.write('performance_metrics', metrics, expires_in: 1.hour)
    
    # JIT optimization: log performance issues
    check_performance_thresholds(metrics)
    
    Rails.logger.info "Performance monitoring completed"
  end
  
  private
  
  def memory_usage
    # JIT optimization: get memory usage
    `ps -o pid,rss,command -p #{Process.pid}`.split("\n")[1]
  rescue
    "N/A"
  end
  
  def database_connections
    # JIT optimization: get database connection stats
    pool = ActiveRecord::Base.connection_pool
    {
      size: pool.size,
      available: pool.available_count,
      checked_out: pool.checked_out_count
    }
  end
  
  def cache_stats
    # JIT optimization: get cache statistics
    if Rails.cache.respond_to?(:stats)
      Rails.cache.stats
    else
      { status: "N/A" }
    end
  end
  
  def redis_stats
    # JIT optimization: get Redis statistics
    if defined?(Redis)
      redis = Redis.current
      {
        memory: redis.info['used_memory_human'],
        connections: redis.info['connected_clients'],
        keys: redis.dbsize
      }
    else
      { status: "N/A" }
    end
  end
  
  def sidekiq_stats
    # JIT optimization: get Sidekiq statistics
    if defined?(Sidekiq)
      stats = Sidekiq::Stats.new
      {
        processed: stats.processed,
        failed: stats.failed,
        queues: stats.queues,
        workers: stats.workers_size
      }
    else
      { status: "N/A" }
    end
  end
  
  def check_performance_thresholds(metrics)
    # JIT optimization: check performance thresholds
    issues = []
    
    # JIT optimization: check memory usage
    if metrics[:memory_usage] && metrics[:memory_usage].include?('MB')
      memory_mb = metrics[:memory_usage].match(/(\d+)MB/)[1].to_i
      if memory_mb > 500 # 500MB threshold
        issues << "High memory usage: #{memory_mb}MB"
      end
    end
    
    # JIT optimization: check database connections
    if metrics[:database_connections][:available] < 2
      issues << "Low database connections available"
    end
    
    # JIT optimization: check Redis connections
    if metrics[:redis_stats][:connections] && metrics[:redis_stats][:connections].to_i > 100
      issues << "High Redis connections: #{metrics[:redis_stats][:connections]}"
    end
    
    # JIT optimization: log issues
    if issues.any?
      Rails.logger.warn "Performance issues detected: #{issues.join(', ')}"
    end
  end
end
