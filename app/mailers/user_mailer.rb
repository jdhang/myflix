class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @url = signin_url
    mail from: 'welcome@myflix.com', to: user.email, subject: "Welcome to MyFLiX.com!"
  end

  def reset_password_email(user)
    @user = user
    @url = reset_password_url(t: @user.secret_token)
    mail from: 'passwordreset@myflix.com', to: user.email, subject: "Password Reset"
  end
end
