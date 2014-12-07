class InvitationMailer
  include Sidekiq::Worker

  def perform(invitation_id)
    AppMailer.delay.send_invitation_email(Invitation.find(invitation_id))
  end
end