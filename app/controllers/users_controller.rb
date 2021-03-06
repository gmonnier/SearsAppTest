require 'digest/md5'


class UsersController < ApplicationController

	before_filter :correct_user, :only => [:show]

	def index
		@title = "Regisetred Users"
		@users = User.paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@title = "Sign up..."
		@user = User.new
	end

	def destroy

		if current_user && current_user.is_admin?
			user = User.find(params[:id])
			if user.destroy
				flash.now[:success] = "User #{user.name} deleted sucessfully"
			else
				flash.now[:error] = "User #{user.name} not deleted"
			end
		else
			flash.now[:error] = "You need to be authenticated as an admin to delete users"
		end
		
		@title = "Regisetred Users"
		@users = User.paginate(:page => params[:page], :per_page => 10)
		render :index
	end

	def show
		@user = User.find(params[:id])
		@gravatar_link = getGravatarLink @user.email

		unless signed_in?
			flash[:error] = "Authentication required to access this page"
			redirect_to :home
		end

	end

	def update
		
		@user = current_user

		respond_to do |format|
			unless current_user.nil?
				#success
				if current_user.update(user_params)
					flash.now[:success] = "Profile information updated succesfully"
					format.js { render js: "$('.ui-dialog-content').dialog('close');" }
				else
					flash.now[:error] = "Error while trying to update your profil information"
					format.js { render js: "alert('hello nok');" }
				end
			else
				redirect_to :home
			end
		end
	end

	def create

		@user = User.new(user_params)
		#success
		if @user.save
			flash[:success] = "Welcome in the application!"
			sign_in @user
			redirect_to user_path(@user)
		else
			@title = "Sign up..."
			render 'new'
		end
	end

	def getGravatarLink(email, size = 50)
		# Create the hash from the e-mail - MD5 encryption
		hash = Digest::MD5.hexdigest(email)
		"http://www.gravatar.com/avatar/#{hash}?s=#{size}"
	end

	private

	def correct_user
		@user = User.find(params[:id])
		redirect_to :root unless current_user?(@user)
	end

	def user_params
		params.require(:user).permit(:name, :email, :pwd, :pwd_confirmation)
	end

	
end

