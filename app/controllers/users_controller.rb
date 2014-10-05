class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:user][:password]
    
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully logged in!"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.update(user_params)
    @user.password = params[:password]

    if @user.save
      flash[:notice] = "User updated."
      redirect_to user_path
    else
      render :edit
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