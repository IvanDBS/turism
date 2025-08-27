class Api::V1::ToursController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search, :featured, :categories]
  
  def index
    tours = Tour.active
    
    # Фильтрация
    tours = tours.by_category(params[:category]) if params[:category].present?
    tours = tours.by_price_range(params[:min_price], params[:max_price]) if params[:min_price].present? || params[:max_price].present?
    tours = tours.by_duration(params[:duration]) if params[:duration].present?
    tours = tours.by_destination(params[:destination]) if params[:destination].present?
    tours = tours.by_departure_city(params[:departure_city]) if params[:departure_city].present?
    tours = tours.by_date_range(params[:start_date], params[:end_date]) if params[:start_date].present? || params[:end_date].present?
    
    # Сортировка
    tours = tours.order_by_rating if params[:sort] == 'rating'
    tours = tours.order_by_price(params[:price_order] || :asc) if params[:sort] == 'price'
    tours = tours.order(created_at: :desc) if params[:sort] == 'newest'
    
    # Пагинация
    tours = tours.page(params[:page] || 1).per(params[:per_page] || 12)
    
    render json: {
      tours: ActiveModel::Serializer::CollectionSerializer.new(tours, serializer: TourSerializer),
      meta: {
        total_pages: tours.total_pages,
        current_page: tours.current_page,
        total_count: tours.total_count
      }
    }
  end
  
  def show
    tour = Tour.find(params[:id])
    render json: tour, serializer: TourSerializer
  end
  
  def search
    tours = Tour.active
    
    if params[:q].present?
      tours = tours.where("title ILIKE ? OR description ILIKE ? OR destination ILIKE ?", 
                         "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%")
    end
    
    tours = tours.page(params[:page] || 1).per(params[:per_page] || 12)
    
    render json: {
      tours: ActiveModel::Serializer::CollectionSerializer.new(tours, serializer: TourSerializer),
      meta: {
        total_pages: tours.total_pages,
        current_page: tours.current_page,
        total_count: tours.total_count
      }
    }
  end
  
  def featured
    tours = Tour.featured.active.limit(6)
    render json: tours, each_serializer: TourSerializer
  end
  
  def categories
    categories = Tour.active.group(:category).count
    render json: categories
  end
  
  def create
    tour = Tour.new(tour_params)
    
    if tour.save
      render json: tour, serializer: TourSerializer, status: :created
    else
      render json: { errors: tour.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    tour = Tour.find(params[:id])
    
    if tour.update(tour_params)
      render json: tour, serializer: TourSerializer
    else
      render json: { errors: tour.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    tour = Tour.find(params[:id])
    tour.destroy
    head :no_content
  end
  
  private
  
  def tour_params
    params.require(:tour).permit(
      :title, :description, :price, :duration, :destination, :image_url, :category,
      :departure_city, :start_date, :end_date, :max_travelers, :min_travelers,
      :included_services, :not_included_services, :itinerary, :accommodation_type,
      :transport_type, :is_featured, :is_active, :rating
    )
  end
end
