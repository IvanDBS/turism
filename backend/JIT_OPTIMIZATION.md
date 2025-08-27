# JIT Optimization Guide

## Обзор

JIT (Just-In-Time) оптимизация настроена для максимальной производительности Rails приложения с интеграцией OBS API.

## Компоненты JIT оптимизации

### 1. Кэширование
- **Redis Cache Store** - основное кэширование
- **OBS API кэширование** - кэш ответов API на 15-30 минут
- **Категории кэширование** - кэш на 24 часа
- **Туры кэширование** - кэш популярных туров

### 2. Фоновые задачи
- **Sidekiq** - обработка фоновых задач
- **ObsSyncJob** - синхронизация с OBS API
- **CacheWarmupJob** - прогрев кэша
- **PerformanceMonitoringJob** - мониторинг производительности

### 3. База данных
- **Connection pooling** - пул соединений
- **Statement timeout** - таймаут запросов
- **Idle timeout** - таймаут неактивных соединений
- **Индексы** - оптимизированные индексы

### 4. JSON оптимизация
- **Oj gem** - быстрый JSON парсер
- **Rails JSON optimization** - оптимизация сериализации

## Команды для JIT оптимизации

### Мониторинг производительности
```bash
# Общий мониторинг
rails performance:monitor

# Прогрев кэша
rails performance:warmup

# Бенчмарк API
rails performance:benchmark

# Профилирование памяти
rails performance:profile

# Оптимизация БД
rails performance:optimize_db
```

### Фоновая синхронизация
```bash
# Запустить фоновую синхронизацию
rails obs:background_sync

# Полная синхронизация в фоне
rails obs:sync_all
```

### Управление кэшем
```bash
# Очистить кэш OBS
rails obs:clear_auth_cache

# Прогреть кэш
rails performance:warmup
```

## Конфигурация

### Переменные окружения
```bash
# Redis
REDIS_URL=redis://localhost:6379/0

# Sidekiq
SIDEKIQ_CONCURRENCY=5

# Puma
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
```

### Автоматическая синхронизация
- **OBS Sync** - каждый час
- **Cache Warmup** - каждые 30 минут
- **Performance Monitoring** - каждые 5 минут

## Мониторинг

### Метрики производительности
- Использование памяти
- Соединения с БД
- Статистика Redis
- Статистика Sidekiq
- Время ответа API

### Логирование
- Все операции логируются
- Ошибки производительности
- Медленные запросы
- Статистика кэша

## Оптимизация API

### Кэширование ответов
```ruby
# Кэш туров на 15 минут
cache_key = "obs_tours_#{params.sort.hash}"
Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
  make_request(:get, '/tours', params)
end
```

### Batch обработка
```ruby
# Обработка туров батчами по 50
tours_data.each_slice(50) do |batch|
  batch.each do |tour_data|
    # Обработка тура
  end
end
```

### Параллельная обработка
```ruby
# Параллельные задачи
jobs = []
jobs << ObsSyncJob.perform_later('categories')
jobs << ObsSyncJob.perform_later('tours', { batch_size: 100 })
```

## Производительность

### Ожидаемые улучшения
- **API ответы** - в 3-5 раз быстрее
- **Синхронизация** - в 2-3 раза быстрее
- **Использование памяти** - на 30-40% меньше
- **Нагрузка на БД** - на 50-60% меньше

### Мониторинг производительности
```bash
# Проверить текущую производительность
rails performance:monitor

# Бенчмарк конкретных операций
rails performance:benchmark

# Профилирование памяти
rails performance:profile
```

## Troubleshooting

### Проблемы с производительностью
1. Проверьте Redis: `redis-cli ping`
2. Проверьте Sidekiq: `rails performance:monitor`
3. Очистите кэш: `rails performance:warmup`
4. Проверьте БД: `rails performance:optimize_db`

### Высокое использование памяти
1. Запустите профилирование: `rails performance:profile`
2. Проверьте кэш: `rails performance:monitor`
3. Очистите кэш: `rails obs:clear_auth_cache`

### Медленные запросы
1. Проверьте индексы: `rails performance:optimize_db`
2. Оптимизируйте запросы
3. Добавьте кэширование

## Рекомендации

### Production
- Используйте Redis для кэширования
- Настройте мониторинг производительности
- Включите автоматическую синхронизацию
- Мониторьте использование памяти

### Development
- Включите MiniProfiler
- Используйте memory profiling
- Мониторьте медленные запросы
- Тестируйте производительность

### Мониторинг
- Настройте алерты на высокое использование памяти
- Мониторьте время ответа API
- Отслеживайте ошибки синхронизации
- Проверяйте статистику кэша
