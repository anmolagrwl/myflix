require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank inputs" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:danger]).to be
      end
    end

    context "with existing email" do
      it "should redirect to forgot passwords confirmation page" do
        Fabricate(:user, email: "corey@corey.codes")
        post :create, email: 'corey@corey.codes'
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "should send out an email to the email address" do
        Fabricate(:user, email: "corey@corey.codes")
        post :create, email: 'corey@corey.codes'
        expect(ActionMailer::Base.deliveries.last.to).to eq(["corey@corey.codes"])
      end
    end
    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "fake@email.com"
        expect(response).to redirect_to forgot_password_path
      end
      it "should show an error message" do
        post :create, email: "fake@email.com"
        expect(flash[:danger]).to have_content "We didn't find that email."
      end
    end
  end
end