class UserMailer < ActionMailer::Base
  default from: "postmaster@sandbox586f3194ead44008a9ca3d27ecb54f98.mailgun.org"

  def welcome_email(user)
    @user = user
    @url = signin_url
    mail to: @user.email, subject: "Welcome to MyFLiX.com!"
  end

  def reset_password_email(user)
    @user = user
    @url = reset_password_url(t: @user.secret_token)
    mail to: @user.email, subject: "Password Reset"
  end

  def invitation_email(invitation)
    @invitation = invitation
    @url = register_url(t: @invitation.id, email: @invitation.email)
    mail to: @invitation.email, subject: "Your friend has invited you to MyFLiX.com"
  end
end
