class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      InvitationMailer.perform_async(@invitation.id)
      flash[:success] = "Invitation sent!"
      redirect_to new_invitation_path
    else
      flash[:danger] = "You forgot some stuff."
      render :new
      @invitation = Invitation.new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end