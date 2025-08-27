# Redis configuration for JIT optimization
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'

# Redis connection pool for better performance
Redis.current = Redis.new(url: redis_url, timeout: 1, reconnect_attempts: 3)

# JIT optimization for caching
Rails.application.configure do
  config.cache_store = :redis_cache_store, {
    url: redis_url,
    namespace: "turism_#{Rails.env}",
    expires_in: 1.hour,
    race_condition_ttl: 10.seconds,
    reconnect_attempts: 3,
    reconnect_delay: 0.5,
    reconnect_delay_max: 2.0,
    error_handler: -> (method:, returning:, exception:) {
      Rails.logger.error "Redis cache error: #{exception.message}"
    }
  }
end

# JIT optimization for session store
Rails.application.config.session_store :redis_store, {
  servers: [redis_url],
  expire_after: 1.week,
  namespace: "turism_session_#{Rails.env}",
  key: '_turism_session',
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
}
