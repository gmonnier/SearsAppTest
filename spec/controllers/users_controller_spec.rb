require 'rails_helper'

RSpec.describe UsersController, type: :controller do
render_views

	describe "Get 'show'" do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "Should succeed" do
			get :show, :id => @user
			expect(response).to have_http_status(:ok)
		end

		it "Should fetch the right user" do
			get :show, :id => @user.id
			assigns(:user).should == @user
		end

		it "Should display users name in an h1 tag" do
			get :show, :id => @user
			expect(response.body).to have_text "#{@user.name}"
		end

		it "Should display a profile image" do
			get :show, :id => @user
			expect(response.body).to have_selector "img", "gravatar"
		end
		
	end

	it describe "Get 'signup'" do
		get 'new'
		expect(response).to have_http_status(:ok)
	end

end
