class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find_by(token: params[:id])
  end

  def new
    if params[:email]
      @id = params[:t]
      @user = User.new(email: params[:email])
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if params[:user][:t]
        invitation = Invitation.find(params[:user][:t])
        follow(@user, invitation.inviter)
        follow(invitation.inviter, @user)
        registered(invitation)
      end
      UserMailer.delay.welcome_email(@user)
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

  def follow(user, follower)
    user.followings.build(follower_id: follower.id)
    user.save
  end

  def registered(invitation)
    invitation.registered = true
    invitation.save
  end
end
