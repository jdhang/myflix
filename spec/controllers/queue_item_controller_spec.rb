require 'spec_helper'

describe QueueItemsController do
  
  describe "GET index" do

    context "with authenticated users" do
      
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = current_user.id
      end

      it "sets @queue" do
        queue1 = Fabricate(:queue_item, video: video, user: current_user)
        queue2 = Fabricate(:queue_item, video: video, user: current_user)
        
        get :index
        expect(assigns(:queue)).to match_array([queue1, queue2])
      end

    end

    context "with unauthenticated users" do
      
      it "redirects to sign in path" do
        get :index
        expect(response).to redirect_to signin_path
      end

    end

  end

  describe "POST create" do
    
    context "with authenticated users" do

      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:monk) { Fabricate(:video, title: "Monk")}

      before do
        session[:user_id] = user.id
      end

      context "and video not in queue will" do

        before do
          queue_item = Fabricate(:queue_item, video: monk, user: user, order: 1)
          post :create, video_id: video.id
        end

        it "create a queue item" do
          expect(QueueItem.count).to eq(2)
        end

        it "create a queue item with the associated video" do
          expect(QueueItem.last.video).to eq(video)
        end
        
        it "create a queue item for the signed in user" do
          expect(QueueItem.last.user).to eq(user)
        end

        it "create a queue item at the end of the queue list" do
          expect(QueueItem.last.order).to eq(2)
        end

        it "redirect to my queue page for authenticated users" do
          expect(response). to redirect_to myqueue_path
        end

      end

      context "and video already in queue will" do

        before do
          queue_item = Fabricate(:queue_item, video: video, user: user, order: 1)
          post :create, video_id: video.id
        end
        
        it "not create a queue item" do
          expect(user.queue_items.count).to eq(1)
        end

        it "flash an error message" do
          expect(flash[:danger]).to_not be_nil
        end

        it "redirect to video page" do
          expect(response).to redirect_to video
        end

      end

    end

    context "with unauthenticated users" do

      it "redirects to sign in page" do
        post :create, video_id: Fabricate(:video).id

        expect(response).to redirect_to signin_path
      end

    end

  end

  describe "DELETE destroy" do
    
    context "with authenticated users" do

      let(:current_user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, order: 1, user: current_user)}

      before do
        session[:user_id] = current_user.id
      end
      
      it "redirects to my queue path" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to myqueue_path
      end

      it "deletes queue item" do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete queue item if queue item does not belong to the current user" do
        bob = Fabricate(:user)
        queue_item1 = queue_item
        queue_item2 = Fabricate(:queue_item, user: bob)

        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(2)
      end

      it "reorders remaining queue items" do
        queue_item2 = Fabricate(:queue_item, order: 2, user: current_user)
        queue_item3 = Fabricate(:queue_item, order: 3, user: current_user)
        queue_item4 = Fabricate(:queue_item, order: 4, user: current_user)

        delete :destroy, id: queue_item3.id
        expect(current_user.queue_items.last.order).to eq(3)
      end

    end

    context "with unauthenticated users" do
      
      it "redirects to sign in path" do
        delete :destroy, id: Fabricate(:queue_item).id
        expect(response).to redirect_to signin_path
      end
    end
  end
end