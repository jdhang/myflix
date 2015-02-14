require 'spec_helper'

describe InvitationController do
  describe "GET new" do
    context "with authenticated users" do
      before do
        set_current_user
        get :new
      end
      it "renders new template" do
        expect(response).to render_template :new
      end
    end
    context "with unauthenticated users" do
      let(:action) { get :new }
      it_behaves_like "require_signin"
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      let(:name) { "Test Dummy" }
      let(:email) { "test@example.com" }
      let(:message) { "Cool site!"}
      before do
        set_current_user
        post :create, name: name, email: email, message: message
      end
      it "sets @user" do
        expect(assigns(:user)).to eq(current_user)
      end
      it "sets @name" do
        expect(assigns(:name)).to eq(name)
      end
      it "sets @email" do
        expect(assigns(:email)).to eq(email)
      end
      it "sets @message" do
        expect(assigns(:message)).to eq(message)
      end
      it "redirects to invite path" do
        expect(response).to redirect_to invite_path
      end
      it "flashes success message" do
        expect(flash[:notice]).to be_present
      end
      it "sends out the invitation email" do
        expect(ActionMailer::Base.deliveries).to be_present
      end
      it "sends from the correct email" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([email])
      end
      it "has the correct content" do
        message = ActionMailer::Base.deliveries.last
        expect(message.subject).to eq("Your friend has invited you to MyFLiX.com")
      end
    end
    context "with unauthenticated users" do
      let(:action) { post :create }
      it_behaves_like "require_signin"
    end
  end
end
