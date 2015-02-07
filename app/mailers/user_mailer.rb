class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail from: 'welcome@myflix.com', to: user.email, subject: "Welcome to MyFLiX.com!"
  end

  def reset_password_email(user)
    @user = user
    mail from: 'donotreply@myflix.com', to: user.email, subject: "Password Reset"
  end
end
