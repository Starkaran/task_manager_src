class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.valid_password?(params[:password])
      sign_in @user
      render json: { message: 'Logged in successfully' }, status: :ok
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end
end
