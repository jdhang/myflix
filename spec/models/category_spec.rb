require 'spec_helper'

describe Category do

  it { expect(subject).to have_many :videos }
  it { expect(subject).to validate_presence_of :name }

  describe "#recent_videos" do
    
    it "returns all videos if there are less than 6 videos" do
      comedies = Category.create(name: "Comedies")
      family_guy = Video.create(title: "Family Guy", description: "awesome show", category: comedies)
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show", category: comedies)
      
      expect(comedies.recent_videos.count()).to eq(2) 
    end
    
    it "returns only 6 recent videos if there are more than 6 videos" do
      comedies = Category.create(name: "Comedies")
      9.times { Video.create(title: "test", description: "a test yo", category: comedies)}
      
      expect(comedies.recent_videos.count()).to eq(6)
    end
    
    it "returns 6 recent videos ordered from most recent to least (created_at)" do
      comedies = Category.create(name: "Comedies")
      family_guy = Video.create(title: "Family Guy", description: "awesome show", category: comedies )
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show", category: comedies )

      expect(comedies.recent_videos).to eq([familiar_guess, family_guy])
    end

    it "returns the 6 most recent videos" do
      comedies = Category.create(name: "Comedies")
      6.times { Video.create(title: "test", description: "a test yo", category: comedies)}
      recent_show = Video.create(title: "new show", description: "its new", category: comedies, created_at: 2.days.ago)

      expect(comedies.recent_videos).to_not include(recent_show)
    end

    it "returns an empty array if there are no videos in the category" do
      comedies = Category.create(name: "Comedies")

      expect(comedies.recent_videos).to eq([])
    end
  end
end