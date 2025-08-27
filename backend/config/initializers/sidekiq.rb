require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  
  # JIT optimization for Sidekiq
  config.concurrency = ENV.fetch('SIDEKIQ_CONCURRENCY', 5).to_i
  
  # Performance monitoring
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 3
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end

# JIT optimization for JSON parsing
require 'oj'
Oj.optimize_rails
