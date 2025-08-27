# Быстрый старт

## 1. Настройка переменных окружения

Создайте файл `.env` в папке `backend/`:

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

## 2. Установка и запуск

```bash
cd backend

# Установка зависимостей
bundle install

# Создание и настройка базы данных
rails db:create
rails db:migrate
rails db:seed

# Проверка статуса OBS API
rails obs:status

# Синхронизация туров (если OBS настроен)
rails obs:sync_tours

# Запуск сервера
rails server
```

## 3. Тестирование API

### Проверка здоровья API
```bash
curl http://localhost:3000/up
```

### Проверка OBS интеграции
```bash
curl http://localhost:3000/api/v1/obs/tours/categories
```

### Регистрация пользователя
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Вход в систему
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## 4. Основные команды

### Синхронизация с OBS
```bash
# Проверить статус
rails obs:status

# Синхронизировать туры
rails obs:sync_tours

# Полная синхронизация
rails obs:sync_all

# Очистить кэш аутентификации
rails obs:clear_auth_cache
```

### Управление данными
```bash
# Создать админа
rails console
User.create!(name: "Admin", email: "admin@example.com", password: "admin123", role: "admin")

# Создать тестовые данные
rails db:seed
```

## 5. Структура API

### Аутентификация
- `POST /api/v1/auth/register` - Регистрация
- `POST /api/v1/auth/login` - Вход
- `GET /api/v1/auth/me` - Текущий пользователь

### Туры
- `GET /api/v1/tours` - Список туров
- `GET /api/v1/tours/:id` - Детали тура

### OBS интеграция
- `GET /api/v1/obs/tours` - Туры из OBS
- `GET /api/v1/obs/tours/categories` - Категории OBS
- `POST /api/v1/obs/bookings` - Бронирование через OBS

### Личный кабинет
- `GET /api/v1/dashboard` - Главная страница
- `GET /api/v1/dashboard/stats` - Статистика
- `GET /api/v1/dashboard/favorites` - Избранные туры

### Синхронизация
- `GET /api/v1/sync/status` - Статус синхронизации
- `POST /api/v1/sync/tours` - Синхронизация туров

## 6. Troubleshooting

### Ошибка подключения к OBS
1. Проверьте переменные окружения
2. Убедитесь, что OBS API доступен
3. Проверьте правильность API ключа

### Ошибки базы данных
1. Убедитесь, что PostgreSQL запущен
2. Проверьте DATABASE_URL
3. Запустите миграции: `rails db:migrate`

### Ошибки CORS
1. Проверьте ALLOWED_ORIGINS
2. Убедитесь, что фронтенд запущен на правильном порту

## 7. Следующие шаги

1. Настройте OBS API ключи
2. Синхронизируйте данные: `rails obs:sync_tours`
3. Создайте админа для управления
4. Настройте автоматическую синхронизацию
5. Интегрируйте с фронтендом
