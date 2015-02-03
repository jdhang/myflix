class FollowingsController < ApplicationController
  before_action :require_user

  def people
    @followings = current_user.followings
  end

  def create
    @user = User.find(params[:user_id])
    @following = @user.followings.build(follower_id: current_user.id)
    if @following.save
      flash[:notice] = "Following #{@user.full_name}."
      redirect_to people_path
    else
      flash[:alert] = "Unable to follow user."
      redirect_to user_path(id: params[:follower_id])
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @following = @user.followings.find_by(follower_id: current_user.id)
    @following.destroy
    flash[:notice] = "Unfollowed #{@user.full_name}."
    redirect_to people_path
  end
end
