# OBS API Configuration
class ObsConfig
  class << self
    def api_url
      ENV['OBS_API_URL'] || 'https://api.obs.md/v1'
    end
    
    def api_key
      ENV['OBS_API_KEY']
    end
    
    def email
      ENV['OBS_EMAIL']
    end
    
    def password
      ENV['OBS_PASSWORD']
    end
    
    def configured?
      api_key.present? && email.present? && password.present?
    end
    
    def auth_token
      return nil unless configured?
      
      # Кэшируем токен на 1 час
      Rails.cache.fetch('obs_auth_token', expires_in: 1.hour) do
        response = ObsService.authenticate(email, password)
        response[:success] ? response[:token] : nil
      end
    end
    
    def clear_auth_cache
      Rails.cache.delete('obs_auth_token')
    end
  end
end
