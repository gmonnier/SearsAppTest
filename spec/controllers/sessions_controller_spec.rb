require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  render_views

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :pwd => "invalid" }
      end

      it "Should redirect to 'new' page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "Should get the right title" do
        post :create, :session => @attr
        expect(response.body).to have_text "Log in"
      end

      it "Should get a flsah error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /Error username-pasword combination/i
      end
    end

    describe "Valid sign in" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        @attr = { :email => @user.email, :pwd => @user.pwd }
      end

      it "Should identify user" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "Should redirect to user's page" do
        post :create, :session => @attr
        expect(response).to redirect_to(user_path(@user))
      end

      it "Should log out connected user" do
        test_sign_in(@user)
        delete :destroy
        controller.should_not be_signed_in
        expect(response).to redirect_to(root_path)
      end

    end

  end

end
