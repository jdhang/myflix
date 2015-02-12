class InvitationController < ApplicationController
  before_action :require_user

  def new
  end

  def create
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    @user = current_user
    UserMailer.invitation_email(@name, @email, @message, @user).deliver
    redirect_to invite_path, notice: "Invitation sent."
  end

end
