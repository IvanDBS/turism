class ObsService
  include HTTParty
  
  BASE_URL = ObsConfig.api_url
  API_KEY = ObsConfig.api_key
  
  class << self
    # Аутентификация с OBS API
    def authenticate(email, password)
      response = HTTP.auth("Basic #{Base64.encode64("#{email}:#{password}").strip}")
                    .headers(accept: 'application/json', content_type: 'application/json')
                    .post("#{BASE_URL}/auth/login", json: { email: email, password: password })
      
      if response.status.success?
        data = JSON.parse(response.body.to_s)
        {
          success: true,
          token: data['token'],
          user: data['user'],
          expires_at: data['expires_at']
        }
      else
        {
          success: false,
          error: parse_error(response)
        }
      end
    rescue => e
      {
        success: false,
        error: "Ошибка соединения: #{e.message}"
      }
    end
    
    # Получить список туров
    def get_tours(params = {})
      # JIT optimization: cache key generation
      cache_key = "obs_tours_#{params.sort.hash}"
      
      Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
        make_request(:get, '/tours', params)
      end
    end
    
    # Получить детали тура
    def get_tour_detail(tour_id)
      # JIT optimization: cache tour details
      cache_key = "obs_tour_detail_#{tour_id}"
      
      Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
        make_request(:get, "/tours/#{tour_id}")
      end
    end
    
    # Поиск туров
    def search_tours(params = {})
      make_request(:get, '/tours/search', params)
    end
    
    # Получить популярные туры
    def get_featured_tours(limit = 6)
      make_request(:get, '/tours/featured', { limit: limit })
    end
    
    # Получить категории туров
    def get_categories
      # JIT optimization: cache categories for longer
      Rails.cache.fetch('obs_categories', expires_in: 24.hours) do
        make_request(:get, '/tours/categories')
      end
    end
    
    # Получить доступность тура
    def get_tour_availability(tour_id, params = {})
      make_request(:get, "/tours/#{tour_id}/availability", params)
    end
    
    # Создать бронирование
    def create_booking(booking_data)
      make_request(:post, '/bookings', booking_data)
    end
    
    # Получить статус бронирования
    def get_booking_status(booking_id)
      make_request(:get, "/bookings/#{booking_id}")
    end
    
    # Синхронизация туров с локальной базой
    def sync_tours
      response = get_tours({ per_page: 100 })
      return response unless response[:success]
      
      tours_data = response[:data]['tours'] || []
      synced_count = 0
      
      tours_data.each do |tour_data|
        tour = Tour.find_or_initialize_by(obs_id: tour_data['id'])
        tour.assign_attributes(
          title: tour_data['title'],
          description: tour_data['description'],
          price: tour_data['price'],
          duration: tour_data['duration'],
          destination: tour_data['destination'],
          category: tour_data['category'],
          image_url: tour_data['image_url'],
          obs_data: tour_data,
          last_synced_at: Time.current
        )
        
        if tour.save
          synced_count += 1
        end
      end
      
      {
        success: true,
        synced_count: synced_count,
        total_tours: tours_data.count
      }
    end
    
    private
    
    def make_request(method, endpoint, params = {})
      headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
      
      # Добавляем авторизацию
      auth_token = ObsConfig.auth_token
      if auth_token.present?
        headers['Authorization'] = "Bearer #{auth_token}"
      elsif API_KEY.present?
        headers['Authorization'] = "Bearer #{API_KEY}"
      end
      
      url = "#{BASE_URL}#{endpoint}"
      
      case method
      when :get
        response = HTTP.headers(headers).get(url, params: params)
      when :post
        response = HTTP.headers(headers).post(url, json: params)
      when :put
        response = HTTP.headers(headers).put(url, json: params)
      when :delete
        response = HTTP.headers(headers).delete(url)
      end
      
      if response.status.success?
        {
          success: true,
          data: JSON.parse(response.body.to_s),
          status: response.status.code
        }
      else
        {
          success: false,
          error: parse_error(response),
          status: response.status.code
        }
      end
    rescue => e
      {
        success: false,
        error: "Ошибка соединения: #{e.message}"
      }
    end
    
    def parse_error(response)
      begin
        error_data = JSON.parse(response.body.to_s)
        error_data['message'] || error_data['error'] || 'Неизвестная ошибка'
      rescue
        case response.status.code
        when 400
          'Неверный запрос'
        when 401
          'Ошибка аутентификации'
        when 403
          'Доступ запрещен'
        when 404
          'Ресурс не найден'
        when 422
          'Ошибка валидации'
        when 429
          'Превышен лимит запросов'
        when 500..599
          'Ошибка сервера'
        else
          'Неизвестная ошибка'
        end
      end
    end
  end
end
