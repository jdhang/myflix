require 'spec_helper'

describe FollowingsController do
  describe "GET people" do
    context "with authenticated users" do
      let(:following) { Fabricate(:following, follower_id: current_user.id) }
      before do
        set_current_user
        get :people
      end
      it "sets @followings" do
        expect(assigns(:followings)).to eq([following])
      end
    end
    context "with unauthenticated users" do
      let(:action) { get :people }
      it_behaves_like "require_signin"
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        request.env["HTTP_REFERER"] = "previous_page"
        post :create, user_id: user.id
      end
      it "sets @user" do
        expect(assigns(:user)).to eq(user)
      end
      it "sets @following" do
        expect(assigns(:following)).to be_an_instance_of(Following)
      end
      it "logged in user is added to selected user's followers" do
        expect(assigns(:user).followers).to eq([current_user])
      end
      it "flashes success message" do
        expect(flash[:notice]).to_not be_nil
      end
      it "redirects to previous page" do
        expect(response).to redirect_to "previous_page"
      end
    end
    context "with unauthenticated users" do
      let(:action) { post :create }
      it_behaves_like "require_signin"
    end
  end

  describe "DELETE destroy" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        request.env["HTTP_REFERER"] = "previous_page"
        @following = user.followings.create(follower_id: current_user.id)
        delete :destroy, user_id: user.id
      end
      it "sets @following" do
        expect(assigns(:following)).to eq(@following)
      end
      it "unfollows user for logged in user" do
        expect(current_user.followings.count).to eq(0)
      end
      it "flashes success message" do
        expect(flash[:notice]).to_not be_nil
      end
      it "redirects to previous page" do
        expect(response).to redirect_to "previous_page"
      end
    end
    context "with unauthenticated users" do
      let(:user) { Fabricate(:user) }
      let(:action) { delete :destroy, follower_id: user.id }
      it_behaves_like "require_signin"
    end
  end
end
