require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      assigns(:video).should eq(video)
    end

    it "sets @reviews for autenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      assigns(:video).should eq(video)
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects unauthenticated users to the signin page" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it "sets @video_search_results for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, query: 'rama'
      expect(assigns(:video_search_results)).to eq([futurama])
    end
    
    it "redirects to sign in page for unauthenticated users" do
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, query: 'rama'
      expect(response).to redirect_to sign_in_path
    end
  end
end
