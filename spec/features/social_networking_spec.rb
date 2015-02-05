require 'spec_helper'

feature "Social networking" do
  scenario "Following a user" do
    # setup
    jason = Fabricate(:user, full_name: "Jason Hang")
    bob = Fabricate(:user, full_name: "Bob Bobby")
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    Fabricate(:review, author: bob, video: monk)

    sign_in(jason)
    click_on_video(monk)

    click_on_review_author(bob)

    click_link "Follow"

    expect(page).to have_content "Following #{bob.full_name}"
  end

  scenario "Unfollowing a user" do
    # setup
    jason = Fabricate(:user, full_name: "Jason Hang")
    bob = Fabricate(:user, full_name: "Bob Bobby")
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    Fabricate(:review, author: bob, video: monk)
    Fabricate(:following, user_id: bob.id, follower_id: jason.id)

    sign_in(jason)
    click_on_video(monk)

    click_on_review_author(bob)

    click_link "Unfollow"

    expect(page).to have_content "Unfollowed #{bob.full_name}"
  end
end

def click_on_video(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
end

def click_on_review_author(author)
  click_link "#{author.full_name}"
end
