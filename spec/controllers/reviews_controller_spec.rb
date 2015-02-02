require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = current_user.id
      end

      context "with valid input" do

        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "create a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.author).to eq(current_user)
        end

        it "redirects to video show page of reviewed video" do
          expect(response).to redirect_to video_path(video)
        end

      end

      context "with invalid input" do

        before do
          post :create, review: { rating: 5 }, video_id: video.id
        end

        it "does not create a review" do
          expect(Review.count).to eq(0)
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end
        it "renders video#show template" do
          expect(response).to render_template 'videos/show'
        end
      end
    end

    context "with unauthenticated users" do
      before do
        avatar = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: avatar.id
      end
      it "redirects to sign in path" do
        expect(response).to redirect_to signin_path
      end
    end
  end
end
