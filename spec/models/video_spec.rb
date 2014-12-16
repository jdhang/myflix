require 'spec_helper'

describe Video do

  it { expect(subject).to belong_to :category }
  it { expect(subject).to have_many :reviews }
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_presence_of :description }

  context "returning reviews" do
    it "with most recent first" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      review1 = Fabricate(:review, created_at: 2.days.ago, author: bob)
      review2 = Fabricate(:review, created_at: 3.days.ago, author: bob)
      review3 = Fabricate(:review, created_at: 1.days.ago, author: bob)
      video.reviews << [review1, review2, review3]

      expect(video.reviews).to eq([review3, review1, review2])
    end
  end

  describe "search_by_title" do
    it "returns an empty array if nothing is found" do
      family_guy = Video.create(title: "Family Guy", description: "awesome show")
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array with a single result for an exact match" do
      family_guy = Video.create(title: "Family Guy", description: "awesome show")
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show")
      expect(Video.search_by_title("Family Guy")).to eq ([family_guy]) 
    end

    it "returns an array with a single result for a partial match" do
      family_guy = Video.create(title: "Family Guy", description: "awesome show")
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show")
      expect(Video.search_by_title("iliar")).to eq ([familiar_guess])
    end

    it "returns all matches ordered by created_at" do
      family_guy = Video.create(title: "Family Guy", description: "awesome show", created_at: 1.day.ago)
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show")
      expect(Video.search_by_title("Fam")).to eq([familiar_guess, family_guy])
    end

    it "returns an empty array if the search is an empty string" do
      family_guy = Video.create(title: "Family Guy", description: "awesome show", created_at: 1.day.ago)
      familiar_guess = Video.create(title: "Familiar Guess", description: "good show")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#rating" do
    
    it "returns 'No ratings yet' when there are no reviews" do
      video = Fabricate(:video)

      expect(video.rating).to eq("No ratings yet")
    end

    it "returns correct average rating when there are reviews" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      review1 = Fabricate(:review, author: bob, rating: 5)
      review2 = Fabricate(:review, author: bob, rating: 5)
      review3 = Fabricate(:review, author: bob, rating: 5)
      video.reviews << [review1, review2, review3]

      expect(video.rating).to eq("5.0/5.0")
    end

  end

end