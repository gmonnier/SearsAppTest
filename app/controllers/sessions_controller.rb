class SessionsController < ApplicationController

  def destroy
  	sign_out
  	redirect_to root_path
  end

  def create
  	authUser = User.authenticate params[:session][:email], params[:session][:pwd]
  	if authUser.nil?
  		flash.now[:error] = "Error username-pasword combination"
  		@title = "Log in"
  		render 'new'
  	else
  		sign_in authUser
  		redirect_to user_path(authUser)
  	end
  end

end
