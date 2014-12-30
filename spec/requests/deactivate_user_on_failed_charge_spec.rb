require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_15FHF8Cf2xtNtL5JWjn3dCUP",
      "created" => 1419912266,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15FHF8Cf2xtNtL5JcegEH1aP",
          "object" => "charge",
          "created" => 1419912266,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "captured" => false,
          "card" => {
            "id" => "card_15FH7QCf2xtNtL5JxNEC37DM",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 12,
            "exp_year" => 2019,
            "fingerprint" => "zRcsWw3cKD8X8Y1i",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_5Q2668BMKfVR6Q"
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5Q2668BMKfVR6Q",
          "invoice" => nil,
          "description" => "failed charge",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "MYFLIX",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15FHF8Cf2xtNtL5JcegEH1aP/refunds",
            "data" => []
          },
          "statement_description" => "MYFLIX"
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5Q7UVLN6xwYzHM",
      "api_version" => "2014-12-08"
      }
  end

  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5Q2668BMKfVR6Q")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end