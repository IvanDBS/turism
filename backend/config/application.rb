require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Turism
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w(assets tasks))
    config.api_only = true
    
    # JIT Configuration
    config.force_ssl = false
    config.ssl_options = { redirect: { exclude: -> request { request.path =~ /health/ } } }
    
    # Performance optimizations
    config.active_record.cache_versioning = true
    config.active_record.collection_cache_versioning = true
    config.active_record.belongs_to_required_by_default = true
    config.active_record.default_timezone = :utc
    
    # JSON optimization
    config.active_support.use_standard_json_time_format = true
    config.active_support.escape_html_entities_in_json = true
    
    # Caching
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
    
    # Background jobs
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "turism_#{Rails.env}"
    
    # Logging optimization
    config.log_level = :info
    config.log_formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{msg}\n"
    end
  end
end
