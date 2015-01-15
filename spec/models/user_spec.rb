require 'spec_helper'

describe User do
  it {expect(subject).to have_many :reviews}
  it {expect(subject).to have_many(:queue_items).order :position}
  it {expect(subject).to validate_presence_of :email}
  it {expect(subject).to validate_presence_of :password}
  it {expect(subject).to validate_presence_of :full_name}
  it {expect(subject).to validate_uniqueness_of :email}

  describe "#queued_videos?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "returns false when the hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsey
    end
  end
end
