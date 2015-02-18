require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "with authenticated users" do
      context "who are admins" do
        before do
          set_current_admin
          get :new
        end
        it "sets @video" do
          expect(assigns(:video)).to be_an_instance_of Video
          expect(assigns(:video)).to be_new_record
        end
        it "renders new template" do
          expect(response).to render_template :new
        end
        it "does not flash error message" do
          expect(flash[:error]).to be_nil
        end
      end
      context "who are not admins" do
        let(:action) { get :new }
        it_behaves_like "require_admin"
      end
    end
    context "with unauthenticated users" do
      let(:action) { get :new }
      it_behaves_like "require_signin"
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      context "who are admins" do
        before do
          set_current_admin
        end
        context "with valid inputs" do
          before do
            post :create, video: Fabricate.attributes_for(:video, category: Fabricate(:category))
          end
          it "creates a video" do
            expect(Video.count).to eq(1)
          end
          it "redirects to add new video path" do
            expect(response).to redirect_to new_admin_video_path
          end
          it "flashes success message" do
            expect(flash[:notice]).to be_present
          end
        end
        context "with invalid inputs" do
          before do
            post :create, video: { description: "Good show!", category_id: Fabricate(:category).id }
          end
          it "does not create a video" do
            expect(Video.count).to eq(0)
          end
          it "renders new template" do
            expect(response).to render_template :new
          end
          it "sets the @video variable" do
            expect(assigns(:video)).to be_present
          end
          it "flashes error message" do
            expect(flash[:error]).to be_present
          end
        end
      end
      context "who are not admins" do
        let(:action) { post :create }
        it_behaves_like "require_admin"
      end
    end
    context "with unathenticated users" do
      let(:action) { post :create }
      it_behaves_like "require_signin"
    end
  end
end
