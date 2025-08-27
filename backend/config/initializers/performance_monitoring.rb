# JIT optimization: Performance monitoring configuration
if Rails.env.development?
  # JIT optimization: MiniProfiler for development
  require 'rack-mini-profiler'
  
  # Initialize MiniProfiler
  Rack::MiniProfilerRails.initialize!(Rails.application)
  
  # JIT optimization: configure MiniProfiler
  Rack::MiniProfiler.config.position = 'bottom-right'
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.skip_paths = ['/assets', '/favicon.ico']
end

# JIT optimization: Memory profiling
if Rails.env.development? || Rails.env.test?
  # JIT optimization: enable memory profiling
  require 'memory_profiler'
  
  # JIT optimization: configure memory profiler
  MemoryProfiler.configure do |config|
    config.ignore_files = /vendor\/bundle/
    config.ignore_files = /gems/
  end
end

# JIT optimization: Stack profiling
if Rails.env.development?
  require 'stackprof'
  
  # JIT optimization: configure stack profiler
  StackProf.configure do |config|
    config.mode = :cpu
    config.interval = 1000
    config.raw = true
  end
end

# JIT optimization: Application performance monitoring
Rails.application.configure do
  # JIT optimization: enable performance monitoring
  config.after_initialize do
    # JIT optimization: log slow queries
    if Rails.env.development?
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger.level = Logger::INFO
    end
    
    # JIT optimization: monitor memory usage
    if Rails.env.development?
      Rails.logger.info "Memory usage: #{`ps -o pid,rss,command -p #{Process.pid}`.split("\n")[1]}"
    end
  end
end
