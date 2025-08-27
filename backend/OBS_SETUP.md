# Настройка интеграции с OBS API

## Переменные окружения

Создайте файл `.env` в корне проекта backend с следующими переменными:

```bash
# OBS API Configuration
OBS_API_URL=https://api.obs.md/v1
OBS_API_KEY=your_obs_api_key_here
OBS_EMAIL=your_obs_email@example.com
OBS_PASSWORD=your_obs_password_here

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/turism_development

# JWT Configuration
SECRET_KEY_BASE=your_secret_key_base_here

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
```

## Установка зависимостей

```bash
cd backend
bundle install
```

## Запуск миграций

```bash
rails db:migrate
```

## Проверка статуса OBS API

```bash
rails obs:status
```

## Синхронизация данных

### Синхронизация туров
```bash
rails obs:sync_tours
```

### Полная синхронизация
```bash
rails obs:sync_all
```

## API Endpoints

### OBS API Integration
- `GET /api/v1/obs/tours` - Получить список туров
- `GET /api/v1/obs/tours/:id` - Получить детали тура
- `GET /api/v1/obs/tours/search` - Поиск туров
- `GET /api/v1/obs/tours/featured` - Популярные туры
- `GET /api/v1/obs/tours/categories` - Категории туров
- `GET /api/v1/obs/tours/:id/availability` - Доступность тура
- `POST /api/v1/obs/bookings` - Создать бронирование
- `GET /api/v1/obs/bookings/:id` - Статус бронирования

### Data Synchronization
- `GET /api/v1/sync/status` - Статус синхронизации
- `POST /api/v1/sync/tours` - Синхронизация туров
- `POST /api/v1/sync/tours/:id` - Синхронизация конкретного тура
- `POST /api/v1/sync/all` - Полная синхронизация

## Тестирование

### Проверка соединения с OBS
```bash
curl -X GET "http://localhost:3000/api/v1/obs/tours/categories" \
  -H "Accept: application/json"
```

### Синхронизация через API
```bash
curl -X POST "http://localhost:3000/api/v1/sync/tours" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

## Структура данных

### Tour Model (обновлен)
- `obs_id` - ID тура в OBS
- `obs_data` - JSON данные из OBS
- `last_synced_at` - Время последней синхронизации
- `image_url` - URL изображения тура

### Методы синхронизации
- `Tour.sync_all_from_obs` - Синхронизация всех туров
- `tour.sync_with_obs!` - Синхронизация конкретного тура
- `tour.from_obs?` - Проверка, является ли тур из OBS

## Мониторинг

### Логи
Все запросы к OBS API логируются в стандартные Rails логи.

### Кэширование
Токен аутентификации кэшируется на 1 час для оптимизации производительности.

### Обработка ошибок
- Автоматический retry при временных ошибках
- Детальное логирование ошибок
- Graceful degradation при недоступности OBS API
