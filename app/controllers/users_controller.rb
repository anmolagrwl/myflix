class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      result = UserSignup.new(@user).sign_up(params[:stripeToken], @user)
      if result.successful?
        flash[:success] = "You have successfully created an account and started your payment. Woohoo!"
        redirect_to sign_in_path
        session[:user_id] = @user.id
      else
        flash[:danger] = result.error_message
        render :new
      end
    else
      flash[:danger] = @user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    @user.update(user_params)

    if @user.save
      flash[:success] = "User updated."
      redirect_to user_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end

  def set_user
    @user = User.find_by(params[:id])
  end
end