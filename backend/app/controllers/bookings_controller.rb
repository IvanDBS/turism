class Api::V1::BookingsController < ApplicationController
  def index
    bookings = current_user.bookings.includes(:tour)
    
    # Фильтрация по статусу
    bookings = bookings.by_status(params[:status]) if params[:status].present?
    
    render json: bookings
  end
  
  def show
    booking = current_user.bookings.find(params[:id])
    render json: booking
  end
  
  def create
    booking = current_user.bookings.build(booking_params)
    
    if booking.save
      render json: booking, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    booking = current_user.bookings.find(params[:id])
    
    if booking.update(booking_params)
      render json: booking
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    booking = current_user.bookings.find(params[:id])
    booking.destroy
    head :no_content
  end
  
  private
  
  def booking_params
    params.require(:booking).permit(:tour_id, :start_date, :end_date, :guests)
  end
end
