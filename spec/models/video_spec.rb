require 'spec_helper'

describe Video do

  it { expect(subject).to belong_to :category }
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_presence_of :description }

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

end