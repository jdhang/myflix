def set_current_user
  bob = Fabricate(:user)
  session[:user_id] = bob.id
end

def set_admin_user
  jim = Fabricate(:user, admin: true)
  session[:user_id] = jim.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit signin_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit signout_path
end
