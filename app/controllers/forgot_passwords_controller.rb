class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: params[:email]).first
    if user
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email can't be blank." : "We didn't find that email."
      redirect_to forgot_password_path      
    end
  end

  def confirm
  end
end