class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path unless user
    end
  end
 
  def expired
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.nullify_token
      user.save
      flash[:success] = "Successfully reset password!"
      redirect_to sign_in_path
    else
      flash[:danger] = "Your token is invalid"
      redirect_to expired_token_path
    end
  end
end