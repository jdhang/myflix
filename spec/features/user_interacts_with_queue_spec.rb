require 'spec_helper'

feature 'User interacts with the queue' do
  scenario 'user adds and reorders videos in the queue' do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)

    sign_in
    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    find("input[data-video-id='#{monk.id}']").set("3")
    find("input[data-video-id='#{south_park.id}']").set("1")
    find("input[data-video-id='#{futurama.id}']").set("2")

    click_button "Update Instant Queue"

    expect(find("input[data-video-id='#{south_park.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{futurama.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{monk.id}']").value).to eq("3")
  end
end

def expect_video_to_be_in_queue(video)
  page.should have_content(video.title)
end

def expect_link_not_to_be_seen(link_text)
  page.should_not have_content(link_text)
end

def add_video_to_queue(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
  click_link "+ My Queue"
end
