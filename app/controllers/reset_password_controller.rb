class ResetPasswordController < ApplicationController

  def new
  end

  def create
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

  def edit
    @user = User.find_by(secret_token: params[:t])
    if @user
      @new_token = SecureRandom.urlsafe_base64
      @user.secret_token = @new_token
      @user.save
    else
      redirect_to link_expired_path
    end
  end

  def update
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

  def confirm
  end

  def link_expired
  end
end
