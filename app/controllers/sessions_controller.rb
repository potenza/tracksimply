class SessionsController < ApplicationController
  def new
    @error = nil
    params[:remember_me] = "1" # turn on by default
  end

  def create
    params.permit(:email, :password, :remember_me)

    user = User.where(["lower(email) = ?", params[:email].downcase]).first
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent.signed[:auth_token] = user.auth_token
      else
        cookies.signed[:auth_token] = user.auth_token
      end

      redirect_to sites_path
    else
      @error = "Invalid email and or password combination."
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to login_path
  end
end
