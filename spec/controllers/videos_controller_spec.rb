require 'spec_helper'

describe VideosController do

  describe "GET index" do

    it "sets the @categories for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      comedies = Fabricate(:category, name: "Comedies")
      avatar = Fabricate(:video, category: comedies)
      monk = Fabricate(:video, category: comedies)

      get :index
      expect(assigns(:categories)).to eq([comedies])
    end

    it "redirect to sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to signin_path
    end

  end

  describe "GET show" do

    it "sets the @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)

      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @review for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)

      get :show, id: video.id
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it "sets @reviews for authenticated users" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, author: bob)
      review2 = Fabricate(:review, video: video, author: bob)

      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirect to sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to signin_path
    end
  end

  describe "GET search" do

    it "sets the @search_results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      family_guy = Fabricate(:video, title: "Family Guy")
      futurama = Fabricate(:video, title: "Futurama")

      get :search, search_terms: "F"
      expect(assigns(:search_results)).to eq( [futurama, family_guy])
    end

    it "redirect to sign in page for unauthenticated users" do
      family_guy = Fabricate(:video, title: "Family Guy")
      futurama = Fabricate(:video, title: "Futurama")

      get :search, search_terms: "F"
      expect(response).to redirect_to signin_path
    end

  end

end
