require 'spec_helper'

describe QueueItem do
  
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:video) }
  it { expect(subject).to validate_numericality_of(:position).only_integer}

  describe "#video_title" do

    it "returns title of associated video" do
      video = Fabricate(:video, title: "Avatar")
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.video_title).to eq("Avatar")
    end

  end

  describe "#rating" do
    
    it "returns rating from review when review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, author: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(4)
    end

    it "returns nil when review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to be_nil
    end

  end

  describe "#category_name" do
    
    it "returns category's name of the video" do
      category = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category_name).to eq("Dramas")
    end

  end

  describe "#category" do

    it "returns the category of the video" do
      category = Fabricate(:category, name: "Dramas")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category).to eq(category)
    end
  end

end