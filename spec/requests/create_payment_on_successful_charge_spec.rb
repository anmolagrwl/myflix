require 'spec_helper'

describe "Create payment on successful charge" do
  let (:event_data) do
    {
      "id" => "evt_15FATvCf2xtNtL5JRIUGEHrI",
      "created" => 1419886275,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15FATvCf2xtNtL5JbTq6XW0n",
          "object" => "charge",
          "created" => 1419886275,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "captured" => true,
          "card" => {
            "id" => "card_15FATuCf2xtNtL5JGiB7X5q5",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 12,
            "exp_year" => 2015,
            "fingerprint" => "ZUV43zFRO2RbtMVO",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => nil,
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_5Q0UowtO7vYNpV"
          },
          "balance_transaction" => "txn_15FATvCf2xtNtL5JETrzIcn6",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_5Q0UowtO7vYNpV",
          "invoice" => "in_15FATvCf2xtNtL5JURGGuWfA",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          },
          "statement_descriptor" => "Myflix BASE PLAN",
          "fraud_details" => {
          },
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15FATvCf2xtNtL5JbTq6XW0n/refunds",
            "data" => [

            ]
          },
          "statement_description" => "Myflix BASE PLAN"
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5Q0U8gEG0350wE",
      "api_version" => "2014-12-08"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5Q0UowtO7vYNpV")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5Q0UowtO7vYNpV")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5Q0UowtO7vYNpV")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15FATvCf2xtNtL5JbTq6XW0n")
  end
end