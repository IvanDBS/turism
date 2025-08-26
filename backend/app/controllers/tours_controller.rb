class Api::V1::ToursController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  def index
    tours = Tour.all
    
    # Фильтрация
    tours = tours.by_category(params[:category]) if params[:category].present?
    tours = tours.by_price_range(params[:min_price], params[:max_price]) if params[:min_price].present? || params[:max_price].present?
    tours = tours.by_duration(params[:duration]) if params[:duration].present?
    
    render json: tours
  end
  
  def show
    tour = Tour.find(params[:id])
    render json: tour
  end
  
  def create
    tour = Tour.new(tour_params)
    
    if tour.save
      render json: tour, status: :created
    else
      render json: { errors: tour.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    tour = Tour.find(params[:id])
    
    if tour.update(tour_params)
      render json: tour
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
    params.require(:tour).permit(:title, :description, :price, :duration, :destination, :image_url, :category)
  end
end
