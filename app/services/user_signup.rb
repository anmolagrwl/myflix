class UserSignup
  
  attr_reader :error_message
  attr_reader :user

  def initialize(user)
    @user = user
    @status = nil
    @error_message = nil
  end
  
  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = attempt_charge(stripe_token, @user)
      if charge.successful?
        process_user_creation(@user, invitation_token)     
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
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

  def attempt_charge(stripe_token, user)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => stripe_token,
      :description => "Payment for #{user.email}"
    )
  end
end