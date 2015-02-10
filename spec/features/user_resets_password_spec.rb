require 'spec_helper'

feature "User resets password" do
  background do
    bob = Fabricate(:user)
    clear_emails

    visit signin_path
    click_link "Forgot Password?"

    fill_in "email", with: bob.email
    click_button "Send Email"

    open_email(bob.email)
  end

  scenario 'email has reset password link' do
    expect(current_email).to have_content "Reset Password"
  end

  scenario 'follows the reset password link' do
    current_email.click_link "Reset Password"
    expect(page).to have_content "Reset Your Password"
  end

  scenario 'password is reset successfully' do
    current_email.click_link "Reset Password"

    fill_in "password", with: "testtest"
    click_button "Reset Password"

    expect(page).to have_content "Password was successfully reset."
  end

end
