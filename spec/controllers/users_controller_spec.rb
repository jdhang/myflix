require 'spec_helper'

describe UsersController do
  describe "GET show" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        get :show, id: user.token
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
      it "flashes success message" do
        expect(flash[:notice]).to be_present
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
    context "email sending" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).to be_present
      end
      it "sends from the right email" do
        message = ActionMailer::Base.deliveries.last
        expect(message.from).to eq(["welcome@myflix.com"])
      end
      it "sends to the right user" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([User.first.email])
      end
      it "has the right content" do
        message = ActionMailer::Base.deliveries.last
        expect(message.subject).to eq('Welcome to MyFLiX.com!')
      end
    end
  end

  describe "POST submit_forgot_password" do
    context "email exists in the database" do
      let(:user) { Fabricate(:user) }
      before do
        post :submit_forgot_password, email: user.email
      end
      it "sets @user" do
        expect(assigns(:user)).to eq(user)
      end
      it "sets user's secret token" do
        expect(User.first.secret_token).to be_present
      end
      it "redirects to confirm password reset path" do
        expect(response).to redirect_to confirm_password_reset_path
      end
    end
    context "email does not exist in the database" do
      before do
        post :submit_forgot_password, email: "sample@example.com"
      end
      it "flashes error message" do
        expect(flash[:error]).to be_present
      end
      it "redirects to forgot password path" do
        expect(response).to redirect_to forgot_password_path
      end
    end
  end

  describe "GET reset_password" do
    context "link has not been clicked yet" do
      let(:token) { SecureRandom.urlsafe_base64 }
      let(:user) { Fabricate(:user, secret_token: token) }
      before do
        get :reset_password, t: user.secret_token
      end
      it "sets @user" do
        expect(assigns(:user)).to eq(user)
      end
      it "sets @new_token" do
        expect(assigns(:new_token)).to be_present
      end
      it "sets user with new token" do
        expect(User.first.secret_token).to eq(assigns(:new_token))
      end
      it "renders reset password template" do
        expect(response).to render_template :reset_password
      end
    end
    context "link has already been clicked" do
      let(:token) { SecureRandom.urlsafe_base64 }
      before do
        Fabricate(:user)
        get :reset_password, t: token
      end
      it "cannot find a user" do
        expect(assigns(:user)).to be_nil
      end
      it "redirects to link expired path" do
        expect(response).to redirect_to link_expired_path
      end
    end
  end

  describe "POST submit_reset_password" do
    let!(:user) { Fabricate(:user, secret_token: SecureRandom.urlsafe_base64, password: "testtest") }
    let!(:new_password) { "password" }
    before do
      post :submit_reset_password, t: user.secret_token, password: new_password
    end
    it "sets @user" do
      expect(assigns(:user)).to eq(user)
    end
    it "updates password" do
      expect(User.first.password_digest).to_not eq(user.password_digest)
    end
    it "deletes secret token" do
      expect(User.first.secret_token).to be_nil
    end
    it "flashes success message" do
      expect(flash[:notice]).to be_present
    end
    it "redirects to signin path" do
      expect(response).to redirect_to signin_path
    end
  end
end
