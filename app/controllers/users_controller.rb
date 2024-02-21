class UsersController < ApplicationController
  def create
    @user = User.find_by(email: user_params[:email])

    if @user
      sign_in @user
      render json: { message: 'Signed in successfully' }, status: :ok
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        render json: { message: 'User was successfully created and signed in' }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
