require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    context "with unauthenticated users" do
      before do
        get :new
      end
      it "renders new template" do
        expect(response).to render_template :new
      end
    end
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :new
      end
      it "redirects to home path for authenticated users" do
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before do
        @bob = Fabricate(:user)
        post :create, email: @bob.email, password: @bob.password
      end
      it "sets session[:user_id] (signs user into session)" do
        expect(session[:user_id]).to eq(@bob.id)
      end
      it "sets flash success" do
        expect(flash[:success]).to_not be_blank
      end
      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end
    context "with invalid credentials" do
      before do
        post :create, email: "my@example.com", password: "notright"
      end
      it "does not set session[:user_id] (sign user into session)" do
        expect(session[:user_id]).to be_nil
      end
      it "sets flash danger" do
        expect(flash[:danger]).to_not be_blank
      end
      it "renders :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    context "with successful sign out" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :destroy
      end
      it "resets session[:user_id]" do
        expect(session[:user_id]).to be_nil
      end
      it "sets flash success" do
        expect(flash[:success]).to_not be_blank
      end
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
