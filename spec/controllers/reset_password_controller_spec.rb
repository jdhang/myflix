require 'spec_helper'

describe ResetPasswordController do
  describe "POST create" do
    context "email exists in the database" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email
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
        post :create, email: "sample@example.com"
      end
      it "flashes error message" do
        expect(flash[:error]).to be_present
      end
      it "redirects to forgot password path" do
        expect(response).to redirect_to forgot_password_path
      end
    end
    context "email sending" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email
      end
      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).to be_present
      end
      it "sends to the correct user" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([User.first.email])
      end
      it "has the reset password link" do
        message = ActionMailer::Base.deliveries.last
        expect(message.subject).to eq("Password Reset")
      end
    end
  end

  describe "GET edit" do
    context "link has not been clicked yet" do
      let(:token) { SecureRandom.urlsafe_base64 }
      let(:user) { Fabricate(:user, secret_token: token) }
      before do
        get :edit, t: user.secret_token
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
        expect(response).to render_template :edit
      end
    end
    context "link has already been clicked" do
      let(:token) { SecureRandom.urlsafe_base64 }
      before do
        Fabricate(:user)
        get :edit, t: token
      end
      it "cannot find a user" do
        expect(assigns(:user)).to be_nil
      end
      it "redirects to link expired path" do
        expect(response).to redirect_to link_expired_path
      end
    end
  end

  describe "PATCH update" do
    let!(:user) { Fabricate(:user, secret_token: SecureRandom.urlsafe_base64, password: "testtest") }
    let!(:new_password) { "password" }
    before do
      patch :update, t: user.secret_token, password: new_password
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
