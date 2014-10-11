class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    else
      render :new
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])  
      session[:user_id] = user.id
      flash[:notice] = "You have successfully logged in!"
      redirect_to home_path
    else
      flash[:notice] = "There is an issue with either your email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end
end