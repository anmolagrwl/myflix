require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user, token: 12345)
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "sets @token" do
      alice = Fabricate(:user, token: 12345)
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
    it "redirects to the expired token page if the token is invalid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: "old_password")
        post :create, password: "new_password"
        expect(response).to redirect_to sign_in_path
      end
      it "updates the users password" do
        alice = Fabricate(:user, password: "old_password", token: "12345")
        post :create, password: "new_password", token: "12345"
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end
      it "sets the flash success message" do
        alice = Fabricate(:user, password: "old_password", token: "12345")
        post :create, password: "new_password", token: "12345"
        expect(flash[:success]).to be
      end
      it "sets token to null" do
        alice = Fabricate(:user, password: "old_password", token: "12345")
        post :create, password: "new_password", token: "12345"
        expect(alice.reload.token).to be_nil
      end
    end
    context "with invalid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: "old_password", token: "12345")
        post :create, password: "new_password", token: "12afdfd345"
        expect(response).to redirect_to expired_token_path
      end
      it "sets the flash success message" do
        alice = Fabricate(:user, password: "old_password", token: "12345")
        post :create, password: "new_password", token: "12afdfd345"
        expect(flash[:danger]).to be
      end
    end
  end
end