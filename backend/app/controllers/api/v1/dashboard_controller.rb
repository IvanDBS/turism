class Api::V1::DashboardController < Api::V1::ApplicationController
  before_action :authenticate_user!
  
  # Главная страница личного кабинета
  def index
    dashboard_data = {
      user: current_user.as_json(only: [:id, :name, :email, :created_at]),
      stats: user_stats,
      recent_bookings: recent_bookings,
      favorite_tours: favorite_tours,
      recommendations: tour_recommendations
    }
    
    render json: dashboard_data
  end
  
  # Статистика пользователя
  def stats
    render json: {
      total_bookings: current_user.bookings.count,
      completed_bookings: current_user.bookings.where(status: 'completed').count,
      pending_bookings: current_user.bookings.where(status: 'pending').count,
      total_spent: current_user.bookings.where(status: 'completed').sum(:total_price),
      favorite_categories: favorite_categories,
      travel_history: travel_history
    }
  end
  
  # Настройки профиля
  def profile
    if current_user.update(profile_params)
      render json: { message: 'Профиль обновлен успешно', user: current_user }
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  
  # Уведомления пользователя
  def notifications
    notifications = current_user.notifications.order(created_at: :desc).limit(20)
    render json: notifications
  end
  
  # Отметить уведомление как прочитанное
  def mark_notification_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read_at: Time.current)
    render json: { message: 'Уведомление отмечено как прочитанное' }
  end
  
  # Получить рекомендации туров
  def recommendations
    render json: tour_recommendations
  end
  
  # История бронирований
  def booking_history
    bookings = current_user.bookings
                          .includes(:tour)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(params[:per_page] || 10)
    
    render json: {
      bookings: bookings.map { |booking| booking.as_json(include: :tour) },
      pagination: {
        current_page: bookings.current_page,
        total_pages: bookings.total_pages,
        total_count: bookings.total_count
      }
    }
  end
  
  # Избранные туры
  def favorites
    favorites = current_user.favorite_tours.includes(:tour)
    render json: favorites.map { |fav| fav.tour.as_json }
  end
  
  # Добавить тур в избранное
  def add_to_favorites
    tour = Tour.find(params[:tour_id])
    favorite = current_user.favorite_tours.find_or_create_by(tour: tour)
    
    if favorite.persisted?
      render json: { message: 'Тур добавлен в избранное' }
    else
      render json: { errors: favorite.errors }, status: :unprocessable_entity
    end
  end
  
  # Удалить тур из избранного
  def remove_from_favorites
    favorite = current_user.favorite_tours.find_by(tour_id: params[:tour_id])
    
    if favorite&.destroy
      render json: { message: 'Тур удален из избранного' }
    else
      render json: { error: 'Тур не найден в избранном' }, status: :not_found
    end
  end
  
  private
  
  def user_stats
    {
      total_bookings: current_user.bookings.count,
      completed_bookings: current_user.bookings.where(status: 'completed').count,
      pending_bookings: current_user.bookings.where(status: 'pending').count,
      total_spent: current_user.bookings.where(status: 'completed').sum(:total_price),
      favorite_categories: favorite_categories,
      travel_history: travel_history
    }
  end
  
  def recent_bookings
    current_user.bookings
                .includes(:tour)
                .order(created_at: :desc)
                .limit(5)
                .map { |booking| booking.as_json(include: :tour) }
  end
  
  def favorite_tours
    current_user.favorite_tours
                .includes(:tour)
                .limit(6)
                .map { |fav| fav.tour.as_json }
  end
  
  def tour_recommendations
    # Простая логика рекомендаций на основе истории пользователя
    user_categories = current_user.bookings.joins(:tour).pluck('tours.category').uniq
    
    if user_categories.any?
      Tour.where(category: user_categories)
          .where.not(id: current_user.bookings.pluck(:tour_id))
          .limit(6)
          .as_json
    else
      Tour.featured.limit(6).as_json
    end
  end
  
  def favorite_categories
    current_user.bookings
                .joins(:tour)
                .group('tours.category')
                .count
                .sort_by { |_, count| -count }
                .first(5)
                .to_h
  end
  
  def travel_history
    current_user.bookings
                .where(status: 'completed')
                .joins(:tour)
                .group('tours.destination')
                .count
                .sort_by { |_, count| -count }
                .first(10)
                .to_h
  end
  
  def profile_params
    params.require(:user).permit(:name, :email, :phone, :date_of_birth, :preferences)
  end
end
