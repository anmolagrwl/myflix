require 'spec_helper'

describe StripeWrapper do
  let(:token) do
      Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 12,
          :exp_year => 2018,
          :cvc => "314"
        },
      ).id
  end
  describe StripeWrapper::Charge do
    context "with valid card" do
      let(:card_number) { "4242424242424242" }

      describe ".create" do
        let(:charge) {
          StripeWrapper::Charge.create(
            :amount => 999,
            :card => token,
            :description => "a valid charge"
          )
        }
        it "makes a successful charge", :vcr do
          charge.should be_successful          
        end
        it "charges the correct amount", :vcr do
          expect(charge.response.amount).to eq(999)
        end
        it "uses USD as currency", :vcr do
          expect(charge.response.currency).to eq("usd")
        end
      end
    end
    
    context "with invalid card" do
      let(:card_number) { "4000000000000002" }

      it "does not charge the card successfully", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :card => token,
          :description => "an invalid charge"
        )
        response.should_not be_successful
      end
      it "contains an error message", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :card => token,
          :description => "an invalid charge"
        )
        response.error_message.should == "Your card was declined."
      end
    end     
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      context "with a valid card" do
        let(:card_number) { "4242424242424242" }
        
        it "creates a customer", :vcr do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: token
          )
          expect(response).to be_successful
        end

        it "returns the customer token", :vcr do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: token
          )
          expect(response.customer_token).to be_present
        end
      end
      
      context "with an invalid card", :vcr do
        let(:card_number) { "4000000000000002" }
        
        it "does not create a customer" do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: token
          )
          expect(response).to_not be_successful
        end

        it "returns the error message" do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: token
          )
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end