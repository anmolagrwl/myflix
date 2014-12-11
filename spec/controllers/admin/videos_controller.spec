require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
    
    it "sets the @video to a new video" do
      set_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "redirects regular user to home path" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets flash warning" do
      set_current_user
      get :new
      expect(flash[:danger]).to be
    end
  end
end