require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to root for logged in user" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders new template for logged out user" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let(:wilson) { Fabricate(:user) }
      before do
        post :create, email: wilson.email, password: wilson.password
      end

      it "should set the user id to the session id" do
        expect(session[:user_id]).to eq(wilson.id)
      end
      
      it "should flash a notice" do
        expect(flash[:success]).not_to be_blank
      end
      
      it "should redirect to home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid credentials" do
      let(:wilson) { Fabricate(:user) }
      before do
        post :create, email: wilson.email, password: "wrongpass"
      end
      it "should not set session user_id" do
        expect(session[:user_id]).to be_blank
      end
      it "should flash a error notice" do
        expect(flash[:danger]).to be
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "should set the session user id to nil" do
      expect(session[:user_id]).to be_blank
    end
    it "should flash a notice" do
      expect(flash[:success]).not_to be_blank
    end
    it "should redirect to homepage" do
      expect(response).to redirect_to root_path
    end
  end
end
