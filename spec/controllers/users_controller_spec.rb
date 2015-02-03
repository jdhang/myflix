require 'spec_helper'

describe UsersController do
  describe "GET show" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        get :show, id: user.id
      end
      it "set @user" do
        expect(assigns(:user)).to eq(user)
      end
    end

    context "with unauthenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        clear_current_user
        get :show, id: user.id
      end
      it "redirects to signin path" do
        expect(response).to redirect_to signin_path
      end
      it "flashes error message" do
        expect(flash[:danger]).to_not be_nil
      end
    end
  end

  describe "GET new" do
    it "set @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "creates user" do
        expect(User.count).to eq(1)
      end
      it "redirects to sign in path" do
        expect(response).to redirect_to signin_path
      end
    end
    context "with invalid input" do
      before do
        post :create, user: { email: "sample@example.com", full_name: "Full Name" }
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end

      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end
