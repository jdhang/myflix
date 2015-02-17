require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "with authenticated users" do
      context "who are admins" do
        before do
          set_admin_user
          get :new
        end
        it "renders new template" do
          expect(response).to render_template :new
        end
        it "does not flash error message" do
          expect(flash[:error]).to be_nil
        end
      end
      context "who are not admins" do
        before do
          set_current_user
          get :new
        end
        it "redirects to root path" do
          expect(response).to redirect_to root_path
        end
        it "flashes error message" do
          expect(flash[:error]).to be_present
        end
      end
    end
    context "with unauthenticated users" do
      let(:action) { get :new }
      it_behaves_like "require_signin"
    end
  end
end
