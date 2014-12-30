class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    else
      render :new
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "You have successfully logged in!"
        redirect_to home_path
      else
        flash[:danger] = "Your account has been suspended, please contact support."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "There is an issue with either your email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to root_path
  end
end
