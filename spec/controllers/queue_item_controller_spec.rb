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
          queue_item = Fabricate(:queue_item, video: monk, user: user, position: 1)
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
          expect(QueueItem.last.position).to eq(2)
        end

        it "redirect to my queue page for authenticated users" do
          expect(response). to redirect_to myqueue_path
        end

      end

      context "and video already in queue will" do

        before do
          queue_item = Fabricate(:queue_item, video: video, user: user, position: 1)
          post :create, video_id: video.id
        end
        
        it "not create a queue item" do
          expect(user.queue_items.count).to eq(1)
        end

        it "flash an error message" do
          expect(flash[:alert]).to_not be_nil
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

  describe "POST update_queue" do

    context "with authenticated users" do

      let(:current_user) { Fabricate(:user) }
      let(:review1) { Fabricate(:review, rating: 3, author: current_user) }
      let(:review2) { Fabricate(:review, rating: 4, author: current_user) }
      let(:video1) { Fabricate(:video, reviews: [review1])}
      let(:video2) { Fabricate(:video, reviews: [review2])}
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user, video: video1) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user, video: video2) }
      let(:queue_item3) { Fabricate(:queue_item, position: 3, user: current_user, video: Fabricate(:video) ) }

      before do
        session[:user_id] = current_user.id
      end

      context "with valid inputs" do

        it "redirects to my queue path" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1},{id: queue_item2.id, position: 2},{id: queue_item3.id, position: 3}]
          expect(response).to redirect_to myqueue_path
        end

        it "reorders the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1},{id: queue_item3.id, position: 3}]
          expect(current_user.queue_items).to eq([queue_item2, queue_item1, queue_item3])
        end

        it "normalizes queue position numbers" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 4},{id: queue_item2.id, position: 2},{id: queue_item3.id, position: 3}]
          expect(current_user.queue_items.map(&:position)).to eq([1,2,3])
        end

        it "creates a new review rating for the queue item's video if one doesn't exist" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1},{id: queue_item2.id, position: 2},{id: queue_item3.id, position: 3, rating: 2}]
          expect(queue_item3.reload.rating).to eq(2)
        end

        it "updates the review rating for the queue item's video if one exists" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1, rating: 4},{id: queue_item2.id, position: 2, rating: 2}]
          expect(queue_item2.reload.rating).to eq(2)
        end

        it "does not create a new review rating if one exists" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1, rating: 4},{id: queue_item2.id, position: 2, rating: 2}]
          expect(queue_item2.reload.video.reviews.count).to eq(1) 
        end
      end

      context "with invalid inputs" do     

        it "redirects to my queue path" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3.2},{id: queue_item2.id, position: 2},{id: queue_item3.id, position: 3}]
          expect(response).to redirect_to myqueue_path
        end

        it "sets the flash error message" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5},{id: queue_item2.id, position: 2},{id: queue_item3.id, position: 3}]
          expect(flash[:alert]).to be_present
        end

        it "does not change the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1},{id: queue_item2.id, position: 2.1},{id: queue_item3.id, position: 3}]
          expect(queue_item1.reload.position).to eq(1)
        end
      end
    end

    context "with unauthenticated users" do
      
      it "redirects to sign in page" do
        post :update_queue
        expect(response).to redirect_to signin_path
      end
    end

    context "with queue items that don't belong to current user" do      
    end
  end

  describe "DELETE destroy" do
    
    context "with authenticated users" do

      let(:current_user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, position: 1, user: current_user)}

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

      it "normalizes queue items after deletion" do
        queue_item1 = queue_item
        queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)

        delete :destroy, id: queue_item1.id
        expect(current_user.queue_items.first.position).to eq(1)
      end

      it "does not delete queue item if queue item does not belong to the current user" do
        bob = Fabricate(:user)
        queue_item1 = queue_item
        queue_item2 = Fabricate(:queue_item, user: bob)

        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(2)
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