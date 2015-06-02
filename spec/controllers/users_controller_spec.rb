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

	describe "User's signup Failure" do

		before(:each) do
			@invalid_attr = {:name => "", :email => "", :pwd => "", :pwd_confirmation => ""}
		end

		it "Should fail to invalid new users data" do
			lambda do
				post :create, :user => @invalid_attr
			end.should_not change(User, :count)
		end

		it "Should render the signup page again on not valid data" do
			post :create, :user => @invalid_attr
			expect(response).to render_template('new')
		end
	end

	describe "User's signup succes" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :pwd => "foobar", :pwd_confirmation => "foobar" }
      end

      it "Should create a new User" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "Should redirect toward User's page " do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end    

      it "Should get a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome in the application/i
      end

      it "Should sign in user aftewards" do
      	post :create, :user => @attr
      	controller.should be_signed_in
      end

    end
end
