class UsersController < ApplicationController
  before_action :require_user, :require_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "#@user has been added"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: "#@user has been updated"
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, notice: "#{user} has been deleted"
  end

  private

  def user_params
    params.require(:user).permit(:admin, :first_name, :last_name, :email, :time_zone, :password, :password_confirmation)
  end
end
