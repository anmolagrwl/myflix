module StripeWrapper
  class Charge
    attr_reader :response, :status
    
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          card: options[:card],
          description: options[:description]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :error_message, :status

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
      @status = nil
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          :card => options[:card],
          :email => options[:user].email,
          :plan => "base_plan"
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      status == :success
    end
  end
end