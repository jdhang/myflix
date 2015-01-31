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

  describe "GET add" do
    
    context "with authenticated users" do

      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:monk) { Fabricate(:video, title: "Monk")}

      before do
        session[:user_id] = user.id
      end

      context "and video not in queue will" do

        before do
          queue_item = Fabricate(:queue_item, video: monk, user: user, order: 1)
          get :add, id: video.id
        end

        it "set @queue_item" do
          expect(assigns(:queue_item)).to_not be_nil
        end

        it "create a queue item" do
          expect(QueueItem.count).to eq(2)
        end

        it "create a queue item with the associated video" do
          expect(assigns(:queue_item).video).to eq(video)
        end
        
        it "create a queue item for the signed in user" do
          expect(assigns(:queue_item).user).to eq(user)
        end

        it "create a queue item with the correct order number" do
          expect(assigns(:queue_item).order).to eq(2)
        end

        it "redirect to my queue page for authenticated users" do
          expect(response). to redirect_to myqueue_path
        end

      end

      context "and video already in queue will" do

        before do
          queue_item = Fabricate(:queue_item, video: video, user: user, order: 1)
          get :add, id: video.id
        end
        
        it "not create a queue item" do
          expect(QueueItem.count).to eq(1)
        end

        it "flash an error message" do
          expect(flash[:danger]).to_not be_nil
        end

        it "redirect to video page" do
          expect(response).to redirect_to video
        end

      end

    end

    context "with unauthenticated users" do

      it "redirects to sign in page" do
        post :add, id: Fabricate(:video).id

        expect(response).to redirect_to signin_path
      end

    end


  end


end