class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You have successfully registered"
      redirect_to signin_path
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end
