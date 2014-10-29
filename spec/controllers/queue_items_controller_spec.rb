require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    context "user is authenticated" do
      it "sets @queue_items to the queue items of the logged in user" do
        wilson = Fabricate(:user)
        set_current_user(wilson)
        queue_item1 = Fabricate(:queue_item, user: wilson)
        queue_item2 = Fabricate(:queue_item, user: wilson)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end 

    context "user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end
    end
  end

  describe "POST add_to_queue" do
    context "user is authenticated" do
      let(:video) { Fabricate(:video) }
      before do
        set_current_user
      end
      it "redirects to my queue" do
        post :add_to_queue, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      it "creates the queue item" do
        post :add_to_queue, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item associated with the video" do
        post :add_to_queue, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates queue item associated with the signed in user" do
        post :add_to_queue, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
      it "puts the video as the last position in the queue" do
        video1 = Fabricate(:video)
        Fabricate(:queue_item, video: video1, user: current_user)
        video2 = Fabricate(:video)
        post :add_to_queue, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2.id, user_id: current_user.id).first
        expect(video2_queue_item.position).to eq(2)
      end
      it "does not add the video to the queue if the video is already in the queue" do
        video1 = Fabricate(:video)
        Fabricate(:queue_item, video: video1, user: current_user)
        video2 = Fabricate(:video)
        post :add_to_queue, video_id: video2.id
        expect(current_user.queue_items.count).to eq(2)
      end
    end

    context "user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :add_to_queue, video_id: 3 }
      end
    end
  end

  describe "DELETE destroy" do
    context "user is authenticated" do
      before do
        set_current_user
      end

      it "redirects the user to my queue" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      
      it "does not delete another users queue" do
        squanto = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: squanto)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
      
      it "normalizes the remaining queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      before do
        set_current_user
      end

      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2, video: video) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "should reorder the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid inputs" do

      let(:wilson) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: wilson, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: wilson, position: 2, video: video) }

      before do
        session[:user_id] = wilson.id
      end

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end 
      it "sets the error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end
      it "doesn't change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 4.3}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 2}] }
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        set_current_user
        alice = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 4}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
