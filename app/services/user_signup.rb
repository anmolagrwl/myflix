class UserSignup
  
  attr_reader :error_message
  attr_reader :user
  attr_accessor :status

  def initialize(user)
    @user = user
    @status = nil
    @error_message = nil
  end
  
  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      customer = attempt_create_customer(stripe_token, @user)
      @status = :success
      if customer.successful?
        process_user_creation(@user, invitation_token)
        return self
      else
        @status = :failed
        @error_message = customer.error_message
        return self
      end
    else
      @status = :failed
      @error_message = @user.errors.full_messages
    end
  end

  def successful?
    @status == :success
  end

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

  def process_user_creation(user, invitation_token)
    @user.save
    handle_invitation(invitation_token)
    AppMailer.send_welcome_email(user).deliver       
  end

  def attempt_create_customer(stripe_token, user)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Customer.create(
      :user => user,
      :card => stripe_token
    )
  end
end