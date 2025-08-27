class Api::V1::ObsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [:tours, :tour_detail, :search_tours, :featured_tours, :categories, :tour_availability]
  
  # Получить список туров с OBS.md
  def tours
    response = ObsService.get_tours(build_tour_params)
    handle_service_response(response)
  end
  
  # Получить детали тура
  def tour_detail
    response = ObsService.get_tour_detail(params[:id])
    handle_service_response(response)
  end
  
  # Поиск туров
  def search_tours
    response = ObsService.search_tours(build_search_params)
    handle_service_response(response)
  end
  
  # Получить популярные туры
  def featured_tours
    response = ObsService.get_featured_tours(params[:limit] || 6)
    handle_service_response(response)
  end
  
  # Получить категории туров
  def categories
    response = ObsService.get_categories
    handle_service_response(response)
  end
  
  # Отправить заявку на бронирование
  def create_booking
    response = ObsService.create_booking(build_booking_params)
    handle_service_response(response)
  end
  
  # Получить статус заявки
  def booking_status
    response = ObsService.get_booking_status(params[:id])
    handle_service_response(response)
  end
  
  # Получить доступность тура
  def tour_availability
    response = ObsService.get_tour_availability(params[:id], request.query_parameters)
    handle_service_response(response)
  end
  
  private
  
  def handle_service_response(response)
    if response[:success]
      render json: response[:data]
    else
      render json: { error: response[:error] }, status: response[:status] || :service_unavailable
    end
  end
  
  def build_tour_params
    params.permit(:page, :per_page, :category, :destination, :min_price, :max_price, 
                  :duration, :start_date, :end_date, :sort, :order).to_h
  end
  
  def build_search_params
    params.permit(:q, :page, :per_page, :category, :destination, :min_price, :max_price,
                  :duration, :start_date, :end_date).to_h
  end
  
  def build_booking_params
    {
      tour_id: booking_params[:tour_id],
      travelers_count: booking_params[:travelers_count],
      start_date: booking_params[:start_date],
      end_date: booking_params[:end_date],
      contact_info: booking_params[:contact_info],
      special_requests: booking_params[:special_requests],
      payment_method: booking_params[:payment_method]
    }.compact
  end
  
  def booking_params
    params.require(:booking).permit(
      :tour_id, :travelers_count, :start_date, :end_date, :special_requests, :payment_method,
      contact_info: [:name, :email, :phone, :comment]
    )
  end
  

end
