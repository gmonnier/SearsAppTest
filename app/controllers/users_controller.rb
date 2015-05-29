class UsersController < ApplicationController
  def new
  	  @title = "Sign up..."
  end

  def show
  	  @user = User.find(params[:id])
  	  @gravatar_link = 'http://www.gravatar.com/avatar/' + @user.email + '?s=50'
  end

end
