class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :authenticate_user!, except: [:health_check]
  
  def health_check
    render json: { status: 'ok', message: 'API is running' }
  end
  
  private
  
  def authenticate_user!
    @current_user = current_user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
  
  def current_user
    @current_user ||= authenticate_token
  end
  
  def authenticate_token
    authenticate_with_http_token do |token, options|
      payload = JwtService.decode(token)
      User.find(payload['user_id']) if payload
    end
  end
  
  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
