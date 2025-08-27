class Api::V1::AuthController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]
  
  def register
    user = User.new(user_params)
    
    if user.save
      token = JwtService.encode({ user_id: user.id })
      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          created_at: user.created_at
        },
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
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          created_at: user.created_at
        },
        token: token
      }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  def me
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      role: current_user.role,
      created_at: current_user.created_at
    }
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
