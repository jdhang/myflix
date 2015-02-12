class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @url = signin_url
    mail from: 'welcome@myflix.com', to: @user.email, subject: "Welcome to MyFLiX.com!"
  end

  def reset_password_email(user)
    @user = user
    @url = reset_password_url(t: @user.secret_token)
    mail from: 'passwordreset@myflix.com', to: @user.email, subject: "Password Reset"
  end

  def invitation_email(name, email, message, user)
    @name = name
    @email = email
    @message = message
    @user = user
    @url = register_url(t: @user.token, email: @email)
    mail from: 'invitation@myflix.com', to: @email, subject: "Your friend has invited you to MyFLiX.com"
  end
end
