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
    context "with good input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "create a user" do
        expect(User.count).to eq(1)
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with bad input" do
      before do
        post :create, user: { email: "test@test.com" }
      end
      
      it "doesn't create a user" do
        expect(User.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "sending email" do
      after { ActionMailer::Base.deliveries.clear } 
      
      it "sends the email to the user with valid inputs" do
        post :create, user: { email: "test@test.com", password: "password", full_name: "Testy Testerson" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["test@test.com"])
      end
      it "sends email containing the users name" do
        post :create, user: { email: "test@test.com", password: "password", full_name: "Testy Testerson" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Testy Testerson")
      end
      it "does not send out email with invalid inputs" do
        post :create, user: { email: "test@test.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
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

end
