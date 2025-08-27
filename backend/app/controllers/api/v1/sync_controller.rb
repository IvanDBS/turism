class Api::V1::SyncController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:sync_tours, :sync_all]
  
  # Синхронизация туров с OBS
  def sync_tours
    begin
      response = Tour.sync_all_from_obs
      
      if response[:success]
        render json: {
          message: 'Синхронизация завершена успешно',
          synced_count: response[:synced_count],
          total_tours: response[:total_tours]
        }
      else
        render json: { error: response[:error] }, status: :service_unavailable
      end
    rescue => e
      render json: { error: "Ошибка синхронизации: #{e.message}" }, status: :internal_server_error
    end
  end
  
  # Синхронизация конкретного тура
  def sync_tour
    tour = Tour.find(params[:id])
    
    if tour.from_obs?
      tour.sync_with_obs!
      render json: { message: 'Тур синхронизирован успешно' }
    else
      render json: { error: 'Тур не связан с OBS' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Тур не найден' }, status: :not_found
  end
  
  # Полная синхронизация (туры + категории + другие данные)
  def sync_all
    results = {}
    
    # Синхронизация туров
    tour_response = Tour.sync_all_from_obs
    results[:tours] = tour_response
    
    # Синхронизация категорий
    categories_response = ObsService.get_categories
    results[:categories] = categories_response
    
    render json: {
      message: 'Полная синхронизация завершена',
      results: results
    }
  end
  
  # Получить статус синхронизации
  def sync_status
    last_sync = Tour.maximum(:last_synced_at)
    obs_tours_count = Tour.where.not(obs_id: nil).count
    total_tours_count = Tour.count
    
    render json: {
      last_sync: last_sync,
      obs_tours_count: obs_tours_count,
      total_tours_count: total_tours_count,
      sync_needed: last_sync.nil? || last_sync < 1.hour.ago
    }
  end
  
  private
  
  def ensure_admin
    unless current_user&.admin?
      render json: { error: 'Доступ запрещен' }, status: :forbidden
    end
  end
end
