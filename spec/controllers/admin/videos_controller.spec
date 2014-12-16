require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end
    
    it "sets the @video to a new video" do
      set_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "sets flash warning" do
      set_current_user
      get :new
      expect(flash[:danger]).to be
    end
  end

  describe 'POST create' do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before(:each) do
        set_admin
        category = Fabricate(:category)
        category2 = Fabricate(:category)
      end
      it "creates the video" do
        post :create, video: { title: "Monk", description: "good show", category_ids: [category.id, category2.id] }
        expect(category.videos.count).to eq(1)
      end
      it "redirects to the add new video page" do
        post :create, video: { title: "Monk", description: "good show", category_ids: [category.id, category2.id]  }
        expect(response).to redirect_to new_admin_video_path
      end
      it "sets the flash success message" do
        post :create, video: { title: "Monk", description: "good show", category_ids: [category.id, category2.id]  }
        expect(flash[:success]).to be
      end
    end
    context "with invalid input" do
      it "does not create a video" do
        set_admin
        category = Fabricate(:category)
        post :create, video: { category_ids: category.id, description: "good show!" }
        expect(category.videos.count).to eq(0)
      end
      it "renders the :new template" do
        set_admin
        category = Fabricate(:category)
        post :create, video: { category_ids: category.id, description: "good show!" }
        expect(response).to render_template :new
      end
      it "sets the @video variable" do
        set_admin
        category = Fabricate(:category)
        post :create, video: { category_ids: category.id, description: "good show!" }
        expect(assigns(:video)).to be_instance_of Video
      end
      it "sets the flash error message" do
        set_admin
        category = Fabricate(:category)
        post :create, video: { category_ids: category.id, description: "good show!" }
        expect(flash[:danger]).to be
      end
    end
  end
end