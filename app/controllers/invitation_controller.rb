class InvitationController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))

    if @invitation.save
      UserMailer.delay.invitation_email(@invitation)
      redirect_to invite_path, notice: "Invitation sent."
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end

end
