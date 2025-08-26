class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]
  
  def register
    user = User.new(user_params)
    
    if user.save
      token = JwtService.encode({ user_id: user.id })
      render json: {
        user: UserSerializer.new(user),
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = JwtService.encode({ user_id: user.id })
      render json: {
        user: UserSerializer.new(user),
        token: token
      }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  def me
    render json: UserSerializer.new(current_user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
