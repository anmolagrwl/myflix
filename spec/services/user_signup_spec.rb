require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do    
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        ActionMailer::Base.deliveries = []
      end

      after { ActionMailer::Base.deliveries.clear } 

      it "creates a user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("123", nil)
        expect(User.count).to eq(1)
      end
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be_truthy
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", invitation.token)        
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be_truthy
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", invitation.token)
        expect(Invitation.first.token).to be_nil
      end      
      it "sends the email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end
      it "sends email containing the users name" do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("John Doe")
      end
      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end
    end

    context "valid personal info and declined card" do
      before do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("123", nil)
      end
      
      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end
    end

    context "invalid personal info" do
      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:customer)
      end      
      it "doesn't create a user" do
        UserSignup.new(User.new(email: "joe@example.com")).sign_up("123", nil)
        expect(User.count).to eq(0)
      end     
      it "does not send out email with invalid inputs" do
        ActionMailer::Base.deliveries = []
        StripeWrapper::Customer.should_not_receive(:customer)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end  
end