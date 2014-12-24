require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
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
end