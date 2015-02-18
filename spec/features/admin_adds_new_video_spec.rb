require 'spec_helper'

feature "Admin adds new video" do
  scenario "Admin successfully adds video" do
    jason = Fabricate(:user, admin: true)
    comedies = Fabricate(:category, name: "Comedies")
    sign_in(jason)
    visit new_admin_video_path

    fill_in "Title", with: "Avatar"
    select "Comedies", from: "Category"
    fill_in "Description", with: "awesome show"
    attach_file "Large Cover", "spec/support/uploads/large-cover.jpg"
    attach_file "Small Cover", "spec/support/uploads/small-cover.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"
    expect(page).to have_content "You have successfully added the video"

    sign_out
    sign_in

    visit video_path(Video.last)

    expect(page).to have_selector("img[src='/uploads/large-cover.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")

  end
end
