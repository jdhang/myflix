class FollowingsController < ApplicationController
  before_action :require_user
  before_action :set_return_to, only: [:create, :destroy]

  def people
    @followings = Following.where(follower_id: current_user.id)
  end

  def create
    @user = User.find(params[:user_id])
    @following = @user.followings.build(follower_id: current_user.id)
    if @following.save
      flash[:notice] = "Following #{@user.full_name}."
      redirect_to session.delete(:return_to)
    else
      flash[:alert] = "Unable to follow user."
      redirect_to session.delete(:return_to)
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @following = @user.followings.find_by(follower_id: current_user.id)
    @following.destroy
    flash[:notice] = "Unfollowed #{@user.full_name}."
    redirect_to session.delete(:return_to)
  end
end
