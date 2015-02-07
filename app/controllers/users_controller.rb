class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find_by(token: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver
      flash[:notice] = "You have successfully registered"
      redirect_to signin_path
    else
      render :new
    end
  end

  def forgot_password
  end

  def submit_forgot_password
    @user = User.find_by(email: params[:email])

    if @user
      @user.secret_token = SecureRandom.urlsafe_base64
      @user.save
      UserMailer.reset_password_email(@user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:error] = "Could not find the Email submitted."
      redirect_to forgot_password_path
    end
  end

  def confirm_password_reset
  end

  def link_expired
  end

  def reset_password
    @user = User.find_by(secret_token: params[:t])
    if @user
      @new_token = SecureRandom.urlsafe_base64
      @user.secret_token = @new_token
      @user.save
    else
      redirect_to link_expired_path
    end
  end

  def submit_reset_password
    @user = User.find_by(secret_token: params[:t])
    if @user
      @user.update(password: params[:password])
      @user.secret_token = nil
      @user.save
      redirect_to signin_path, notice: "Password was successfully reset. Please sign in again."
    else
      redirect_to link_expired_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end
