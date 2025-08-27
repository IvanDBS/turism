require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_storage.service = :local
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_job.verbose_enqueue_logs = true
  config.action_controller.raise_on_missing_callback_actions = true
  
  # OBS API Configuration for development
  config.obs_api_url = ENV['OBS_API_URL'] || 'https://api.obs.md/v1'
  config.obs_api_key = ENV['OBS_API_KEY']
  config.obs_email = ENV['OBS_EMAIL']
  config.obs_password = ENV['OBS_PASSWORD']
  
  # CORS Configuration
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins ENV['ALLOWED_ORIGINS']&.split(',') || ['http://localhost:3000', 'http://localhost:5173']
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end
end