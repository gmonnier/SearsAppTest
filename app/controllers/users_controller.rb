class UsersController < ApplicationController

	def new
		@title = "Sign up..."
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@gravatar_link = 'http://www.gravatar.com/avatar/' + @user.email + '?s=50'
	end

	def create

		@user = User.new(user_params)
		#success
		if @user.save
			flash[:success] = "Welcome in the application!"
			redirect_to user_path(@user)
  	  else
  	  	@title = "Sign up..."
  	  	render 'new'
  	  end
  	end

  	private

  	def user_params
  		params.require(:user).permit(:name, :email, :pwd, :pwd_confirmation)
  	end

  end
