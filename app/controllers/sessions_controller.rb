class SessionsController < ApplicationController

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully signed in."
      redirect_to videos_path
    else
      flash[:danger] = "Your email or password was invalid."
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to root_path
  end

end