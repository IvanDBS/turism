namespace :performance do
  desc "JIT optimization: Monitor application performance"
  task monitor: :environment do
    puts "JIT Performance Monitoring"
    puts "=" * 50
    
    # JIT optimization: memory usage
    memory_usage = `ps -o pid,rss,command -p #{Process.pid}`.split("\n")[1]
    puts "Memory Usage: #{memory_usage}"
    
    # JIT optimization: database connections
    db_connections = ActiveRecord::Base.connection_pool.stat
    puts "Database Connections: #{db_connections[:size]} active, #{db_connections[:available]} available"
    
    # JIT optimization: cache statistics
    if Rails.cache.respond_to?(:stats)
      cache_stats = Rails.cache.stats
      puts "Cache Statistics: #{cache_stats}"
    end
    
    # JIT optimization: Redis statistics
    if defined?(Redis)
      redis_stats = Redis.current.info
      puts "Redis Memory: #{redis_stats['used_memory_human']}"
      puts "Redis Connections: #{redis_stats['connected_clients']}"
    end
    
    # JIT optimization: Sidekiq statistics
    if defined?(Sidekiq)
      sidekiq_stats = Sidekiq::Stats.new
      puts "Sidekiq Jobs: #{sidekiq_stats.processed} processed, #{sidekiq_stats.failed} failed"
      puts "Sidekiq Queues: #{sidekiq_stats.queues}"
    end
    
    puts "=" * 50
  end
  
  desc "JIT optimization: Warm up application cache"
  task warmup: :environment do
    puts "JIT Cache Warmup"
    puts "=" * 30
    
    # JIT optimization: warm up cache
    CacheWarmupJob.perform_now
    
    puts "Cache warmup completed"
  end
  
  desc "JIT optimization: Benchmark API endpoints"
  task benchmark: :environment do
    puts "JIT API Benchmarking"
    puts "=" * 30
    
    # JIT optimization: benchmark tours endpoint
    require 'benchmark'
    
    Benchmark.bm(20) do |x|
      x.report("Tours Index:") do
        10.times { Tour.limit(10).to_a }
      end
      
      x.report("Tours with Includes:") do
        10.times { Tour.includes(:bookings).limit(10).to_a }
      end
      
      x.report("OBS API Call:") do
        5.times { ObsService.get_categories }
      end
    end
    
    puts "Benchmarking completed"
  end
  
  desc "JIT optimization: Memory profiling"
  task profile: :environment do
    puts "JIT Memory Profiling"
    puts "=" * 30
    
    # JIT optimization: memory profiling
    require 'memory_profiler'
    
    report = MemoryProfiler.report do
      # JIT optimization: profile tours loading
      Tour.limit(100).includes(:bookings).to_a
      
      # JIT optimization: profile OBS API call
      ObsService.get_tours(limit: 50)
    end
    
    puts "Memory Profiling Results:"
    puts "Total Allocated: #{report.total_allocated_memsize} bytes"
    puts "Total Retained: #{report.total_retained_memsize} bytes"
    puts "Top 5 Allocated Objects:"
    
    report.allocated_memory_by_class.first(5).each do |klass, size|
      puts "  #{klass}: #{size} bytes"
    end
    
    puts "Memory profiling completed"
  end
  
  desc "JIT optimization: Database query optimization"
  task optimize_db: :environment do
    puts "JIT Database Optimization"
    puts "=" * 30
    
    # JIT optimization: analyze slow queries
    slow_queries = ActiveRecord::Base.connection.execute(<<~SQL)
      SELECT query, mean_time, calls, total_time
      FROM pg_stat_statements
      WHERE mean_time > 100
      ORDER BY mean_time DESC
      LIMIT 10;
    SQL
    
    if slow_queries.any?
      puts "Slow Queries Found:"
      slow_queries.each do |query|
        puts "  #{query['query'][0..100]}... (#{query['mean_time']}ms avg)"
      end
    else
      puts "No slow queries found"
    end
    
    # JIT optimization: suggest indexes
    puts "\nSuggested Indexes:"
    puts "  - Add index on tours.obs_id for OBS integration"
    puts "  - Add index on bookings.user_id for user queries"
    puts "  - Add index on tours.category for filtering"
    puts "  - Add index on tours.destination for search"
    
    puts "Database optimization completed"
  end
end
