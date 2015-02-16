require 'spec_helper'

describe InvitationController do
  describe "GET new" do
    context "with authenticated users" do
      before do
        set_current_user
        get :new
      end
      it "sets @invitation" do
        expect(assigns(:invitation)).to be_an_instance_of(Invitation)
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
      context "with valid inputs" do
        before do
          set_current_user
          post :create, invitation: Fabricate.attributes_for(:invitation)
        end
        it "creates an invitation" do
          expect(Invitation.count).to eq(1)
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
          expect(message.to).to eq([Invitation.first.email])
        end
        it "has the correct content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.subject).to eq("Your friend has invited you to MyFLiX.com")
        end
      end
      context "with invalid inputs" do
        before do
          set_current_user
          post :create, invitation: { name: "Name", message: "messages are fun" }
        end
        it "renders new template" do
          expect(response).to render_template :new
        end
      end
    end
    context "with unauthenticated users" do
      let(:action) { post :create }
      it_behaves_like "require_signin"
    end
  end
end
