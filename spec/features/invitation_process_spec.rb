require 'spec_helper'

feature "Invitation Process" do
  background do
    @user = Fabricate(:user, email: "user@example.com")
  end

  scenario "user sends invite to friend" do
    send_invite
    expect(page).to have_content "Invitation sent."
  end

  scenario "friends registration page has email fill in already" do
    send_invite_and_sign_out

    current_email.click_link "Register Now"

    expect(find_by_id("user_email").value).to eq("test@example.com")
  end

  scenario "friend is following user" do
    send_invite_and_sign_out
    friend_registers

    friend_signs_in
    visit people_path

    expect(page).to have_content(@user.full_name)
  end

  scenario "user is following friend" do
    send_invite_and_sign_out
    friend_registers

    sign_in(@user)
    visit people_path

    expect(page).to have_content("Test Dummy")
  end
end

def send_invite
  sign_in(@user)
  visit invite_path

  fill_in "invitation_name", with: "Test Dummy"
  fill_in "invitation_email", with: "test@example.com"
  fill_in "invitation_message", with: "Please join this really cool site!"
  click_button "Send Invitation"

  open_email("test@example.com")
end

def send_invite_and_sign_out
  send_invite
  sign_out
end

def friend_registers
  current_email.click_link "Register Now"

  fill_in "Password", with: "testtest"
  fill_in "Full Name", with: "Test Dummy"
  click_button "Sign Up"
end

def friend_signs_in
  visit signin_path

  fill_in "Email Address", with: "test@example.com"
  fill_in "Password", with: "testtest"
  click_button "Sign in"
end
