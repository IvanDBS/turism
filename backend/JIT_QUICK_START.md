# JIT Quick Start

## 1. Установка зависимостей

```bash
cd backend
bundle install
```

## 2. Настройка Redis

```bash
# Установка Redis (macOS)
brew install redis

# Запуск Redis
redis-server

# Проверка Redis
redis-cli ping
```

## 3. Настройка переменных окружения

Добавьте в `.env`:

```bash
# Redis
REDIS_URL=redis://localhost:6379/0

# Sidekiq
SIDEKIQ_CONCURRENCY=5

# Puma
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
```

## 4. Запуск с JIT оптимизацией

```bash
# Запуск Rails сервера
rails server

# Запуск Sidekiq (в отдельном терминале)
bundle exec sidekiq

# Запуск Sidekiq Web UI (опционально)
bundle exec sidekiq-web
```

## 5. Тестирование JIT оптимизации

### Проверка производительности
```bash
# Мониторинг производительности
rails performance:monitor

# Прогрев кэша
rails performance:warmup

# Бенчмарк API
rails performance:benchmark
```

### Тестирование синхронизации
```bash
# Фоновая синхронизация
rails obs:background_sync

# Проверка статуса
rails obs:status
```

## 6. Мониторинг

### Sidekiq Web UI
Откройте http://localhost:4567 для мониторинга фоновых задач

### Performance Monitoring
```bash
# Текущие метрики
rails performance:monitor

# Профилирование памяти
rails performance:profile
```

## 7. Автоматическая синхронизация

JIT оптимизация включает автоматическую синхронизацию:

- **OBS Sync** - каждый час
- **Cache Warmup** - каждые 30 минут  
- **Performance Monitoring** - каждые 5 минут

## 8. Команды для разработки

### Кэширование
```bash
# Очистить кэш
rails obs:clear_auth_cache

# Прогреть кэш
rails performance:warmup
```

### Синхронизация
```bash
# Синхронизация в фоне
rails obs:background_sync

# Полная синхронизация
rails obs:sync_all
```

### Мониторинг
```bash
# Общий мониторинг
rails performance:monitor

# Оптимизация БД
rails performance:optimize_db
```

## 9. Troubleshooting

### Redis не запущен
```bash
redis-server
```

### Sidekiq не работает
```bash
bundle exec sidekiq
```

### Высокое использование памяти
```bash
rails performance:profile
```

### Медленные запросы
```bash
rails performance:optimize_db
```

## 10. Production настройка

### Переменные окружения
```bash
RAILS_ENV=production
REDIS_URL=redis://your-redis-server:6379/0
SIDEKIQ_CONCURRENCY=10
WEB_CONCURRENCY=4
```

### Запуск в production
```bash
# Запуск Puma
bundle exec puma -C config/puma.rb

# Запуск Sidekiq
bundle exec sidekiq -e production

# Мониторинг
rails performance:monitor
```

## 11. Ожидаемые результаты

### Производительность
- API ответы в 3-5 раз быстрее
- Синхронизация в 2-3 раза быстрее
- Использование памяти на 30-40% меньше

### Масштабируемость
- Поддержка большего количества пользователей
- Быстрая обработка больших объемов данных
- Эффективное использование ресурсов

### Надежность
- Автоматическая обработка ошибок
- Мониторинг производительности
- Graceful degradation при проблемах
