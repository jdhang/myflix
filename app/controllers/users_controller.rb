class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find_by(token: params[:id])
  end

  def new
    if params[:email]
      email = params[:email]
      @token = params[:t]
      @user = User.new(email: email)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if params[:user][:t]
        @referrer = User.find_by(token: params[:user][:t])
        ref_following = @referrer.followings.build(follower_id: @user.id)
        ref_following.save
        following = @user.followings.build(follower_id: @referrer.id)
        following.save
      end
      UserMailer.welcome_email(@user).deliver
      flash[:notice] = "You have successfully registered"
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
