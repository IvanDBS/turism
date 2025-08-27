namespace :obs do
  desc "Синхронизация туров с OBS API"
  task sync_tours: :environment do
    puts "Начинаем синхронизацию туров с OBS..."
    
    unless ObsConfig.configured?
      puts "Ошибка: OBS API не настроен. Проверьте переменные окружения."
      exit 1
    end
    
    response = Tour.sync_all_from_obs
    
    if response[:success]
      puts "Синхронизация завершена успешно!"
      puts "Синхронизировано туров: #{response[:synced_count]}"
      puts "Всего туров в OBS: #{response[:total_tours]}"
    else
      puts "Ошибка синхронизации: #{response[:error]}"
      exit 1
    end
  end
  
  desc "Проверка статуса OBS API"
  task status: :environment do
    puts "Проверяем статус OBS API..."
    
    unless ObsConfig.configured?
      puts "❌ OBS API не настроен"
      puts "Необходимые переменные окружения:"
      puts "  - OBS_API_URL"
      puts "  - OBS_API_KEY или OBS_EMAIL + OBS_PASSWORD"
      exit 1
    end
    
    puts "✅ OBS API настроен"
    puts "API URL: #{ObsConfig.api_url}"
    puts "API Key: #{ObsConfig.api_key.present? ? 'Настроен' : 'Не настроен'}"
    puts "Email: #{ObsConfig.email.present? ? 'Настроен' : 'Не настроен'}"
    
    # Тестируем соединение
    puts "\nТестируем соединение с OBS API..."
    response = ObsService.get_categories
    
    if response[:success]
      puts "✅ Соединение с OBS API работает"
      puts "Получено категорий: #{response[:data]['categories']&.count || 0}"
    else
      puts "❌ Ошибка соединения с OBS API: #{response[:error]}"
    end
  end
  
  desc "Очистка кэша аутентификации OBS"
  task clear_auth_cache: :environment do
    ObsConfig.clear_auth_cache
    puts "Кэш аутентификации OBS очищен"
  end
  
  desc "Полная синхронизация с OBS"
  task sync_all: :environment do
    puts "Начинаем полную синхронизацию с OBS..."
    
    # JIT optimization: use background jobs
    ObsSyncJob.perform_later('all')
    
    puts "✅ Полная синхронизация запланирована в фоновом режиме"
    puts "Проверьте статус через: rails obs:status"
  end
  
  desc "JIT optimization: Запустить фоновую синхронизацию"
  task background_sync: :environment do
    puts "JIT Background Sync"
    puts "=" * 30
    
    # JIT optimization: schedule background jobs
    jobs = []
    
    # JIT optimization: sync tours in batches
    jobs << ObsSyncJob.perform_later('tours', { batch_size: 100, page: 1 })
    
    # JIT optimization: sync categories
    jobs << ObsSyncJob.perform_later('categories')
    
    # JIT optimization: warm up cache
    jobs << CacheWarmupJob.perform_later
    
    puts "✅ Запланировано фоновых задач: #{jobs.count}"
    puts "Проверьте статус через: rails performance:monitor"
  end
end
