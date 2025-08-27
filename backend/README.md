# Tourism Backend API

Backend API для туристического приложения с интеграцией OBS API.

## Возможности

- 🔐 JWT аутентификация
- 🏨 Управление турами и бронированиями
- 🔄 Синхронизация с OBS API
- 👤 Личный кабинет пользователя
- 📊 Аналитика и статистика
- 🔔 Система уведомлений
- ❤️ Избранные туры

## Технологии

- Ruby 3.4.5
- Rails 8.0
- PostgreSQL
- JWT для аутентификации
- HTTP gem для API запросов

## Установка

1. Клонируйте репозиторий
2. Установите зависимости:
   ```bash
   bundle install
   ```

3. Настройте базу данных:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Настройте переменные окружения (см. OBS_SETUP.md)

5. Запустите сервер:
   ```bash
   rails server
   ```

## API Endpoints

### Аутентификация
- `POST /api/v1/auth/register` - Регистрация
- `POST /api/v1/auth/login` - Вход
- `GET /api/v1/auth/me` - Текущий пользователь

### Туры
- `GET /api/v1/tours` - Список туров
- `GET /api/v1/tours/:id` - Детали тура
- `POST /api/v1/tours` - Создать тур (admin)
- `PUT /api/v1/tours/:id` - Обновить тур (admin)
- `DELETE /api/v1/tours/:id` - Удалить тур (admin)

### Бронирования
- `GET /api/v1/bookings` - Мои бронирования
- `GET /api/v1/bookings/:id` - Детали бронирования
- `POST /api/v1/bookings` - Создать бронирование
- `PUT /api/v1/bookings/:id` - Обновить бронирование
- `DELETE /api/v1/bookings/:id` - Отменить бронирование

### OBS API Integration
- `GET /api/v1/obs/tours` - Туры из OBS
- `GET /api/v1/obs/tours/:id` - Детали тура из OBS
- `GET /api/v1/obs/tours/search` - Поиск туров в OBS
- `GET /api/v1/obs/tours/featured` - Популярные туры OBS
- `GET /api/v1/obs/tours/categories` - Категории OBS
- `POST /api/v1/obs/bookings` - Бронирование через OBS

### Синхронизация
- `GET /api/v1/sync/status` - Статус синхронизации
- `POST /api/v1/sync/tours` - Синхронизация туров
- `POST /api/v1/sync/all` - Полная синхронизация

### Личный кабинет
- `GET /api/v1/dashboard` - Главная страница
- `GET /api/v1/dashboard/stats` - Статистика
- `PATCH /api/v1/dashboard/profile` - Обновить профиль
- `GET /api/v1/dashboard/notifications` - Уведомления
- `GET /api/v1/dashboard/favorites` - Избранные туры
- `POST /api/v1/dashboard/favorites/:tour_id` - Добавить в избранное
- `DELETE /api/v1/dashboard/favorites/:tour_id` - Удалить из избранного

## Команды для разработки

### Синхронизация с OBS
```bash
# Проверить статус OBS API
rails obs:status

# Синхронизировать туры
rails obs:sync_tours

# Полная синхронизация
rails obs:sync_all

# Очистить кэш аутентификации
rails obs:clear_auth_cache
```

### Тестирование
```bash
# Запустить тесты
rails test

# Тесты с покрытием
rails test:coverage
```

## Структура проекта

```
app/
├── controllers/
│   └── api/v1/
│       ├── auth_controller.rb
│       ├── tours_controller.rb
│       ├── bookings_controller.rb
│       ├── obs_controller.rb
│       ├── sync_controller.rb
│       └── dashboard_controller.rb
├── models/
│   ├── user.rb
│   ├── tour.rb
│   ├── booking.rb
│   ├── notification.rb
│   └── favorite_tour.rb
├── services/
│   ├── jwt_service.rb
│   └── obs_service.rb
└── serializers/
    ├── user_serializer.rb
    ├── tour_serializer.rb
    └── booking_serializer.rb
```

## Конфигурация

### Переменные окружения
- `OBS_API_URL` - URL OBS API
- `OBS_API_KEY` - API ключ OBS
- `OBS_EMAIL` - Email для OBS
- `OBS_PASSWORD` - Пароль для OBS
- `SECRET_KEY_BASE` - Секретный ключ Rails
- `DATABASE_URL` - URL базы данных

### CORS
Настроен для работы с фронтендом на localhost:3000 и localhost:5173

## Мониторинг

### Логи
- Все запросы к OBS API логируются
- Ошибки синхронизации записываются в логи
- JWT токены логируются для отладки

### Метрики
- Количество синхронизированных туров
- Статистика бронирований
- Активность пользователей

## Безопасность

- JWT токены с истечением срока действия
- Валидация всех входящих данных
- Защита от CSRF атак
- Ограничение доступа к админским функциям

## Развертывание

### Production
1. Настройте переменные окружения
2. Запустите миграции: `rails db:migrate`
3. Предзагрузите данные: `rails db:seed`
4. Настройте cron для автоматической синхронизации
5. Запустите сервер

### Docker
```bash
docker build -t tourism-backend .
docker run -p 3000:3000 tourism-backend
```

## Поддержка

Для вопросов и поддержки обращайтесь к документации OBS API или создайте issue в репозитории.
