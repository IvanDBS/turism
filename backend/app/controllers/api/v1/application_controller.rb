class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user!
  
  private
  
  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    begin
      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
  
  def health_check
    render json: { status: 'ok', timestamp: Time.current }
  end
end
