require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "for authenticated users" do
      before do
        set_current_user
      end

      it "sets the @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        assigns(:video).should eq(video)
      end

      it "sets @reviews" do
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        assigns(:video).should eq(video)
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    context "for unauthenticated users" do
      let(:video) { Fabricate(:video) }
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: video.id}
      end
    end
  end

  describe "GET search" do
    context "for authenticated users" do
      it "sets @video_search_results for authenticated user" do
        set_current_user
        futurama = Fabricate(:video, title: 'Futurama')
        get :search, query: 'rama'
        expect(assigns(:video_search_results)).to eq([futurama])
      end
    end
    
    context "for unauthenticated users" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :search, query: 'rama' }
      end
    end
  end
end
