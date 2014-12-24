require 'spec_helper'

describe UsersController do
  # renders register template on users get
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }
      
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates a user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to sign in path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be_truthy
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be_truthy
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "valid personal info and declined card" do
      before(:each) do
        charge = double(:charge, successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123123"
      end
      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        expect(flash[:danger]).to be
      end
    end

    context "invalid personal info" do  
      before(:each) { post :create, user: { email: "test@test.com" } }
      it "doesn't create a user" do
        expect(User.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send out email with invalid inputs" do
        ActionMailer::Base.deliveries = []
        StripeWrapper::Charge.should_not_receive(:create)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "sending email" do
      # after { ActionMailer::Base.deliveries.clear } 
      before do
        ActionMailer::Base.deliveries = []
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end 
      
      it "sends the email to the user with valid inputs" do
        post :create, user: { email: "test@test.com", password: "password", full_name: "Testy Testerson" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["test@test.com"])
      end
      it "sends email containing the users name" do
        post :create, user: { email: "test@test.com", password: "password", full_name: "Testy Testerson" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Testy Testerson")
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user 
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET new_with_invitation_token" do
    it "should render the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets @invitation_tokenemail" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "redirects to expired token page for invalid token" do
      get :new_with_invitation_token, token: "sldkfjalsdkj"
      expect(response).to redirect_to expired_token_path
    end    
  end

end
