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

    if @user.save && charge_with_stripe
      handle_invitation
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

  def handle_invitation
    if params[:user][:t]
      invitation = Invitation.find(params[:user][:t])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.register
    end
  end

  def charge_with_stripe
    Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
    begin
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
      false
    end
  end
end
