# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  name          :string
#  email         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  encrypted_pwd :string
#  salt          :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
	before(:each) do
		@attr = { :name => "Example User", :email => "Example@gmail.com" , :pwd => "testpwd", :pwd_confirmation => "testpwd"}
		@attrInvalid = { :name => "", :email => "Example@gmail.com", :pwd => "testpwd", :pwd_confirmation => "testpwd"}
	end

	it "Should create user entry inside the database" do
		User.create!(@attr)
	end

	it "Should not create user entry inside the database when provided name is empty" do
		usr = User.new(@attrInvalid)
		usr.should_not be_valid
	end

	it "Should not create user entry inside the database when provided email is empty" do
		usr = User.new(@attrInvalid.merge(:name => "nonEmptyName", :email => ""))
		usr.should_not be_valid
	end

	it "Should not create user with name longer than 25 characters" do
		unvalidName = 'a' * 26
		usr = User.new(@attrInvalid.merge(:name => unvalidName))
		usr.should_not be_valid
	end

	it "Should reject invalid email adress" do
		adressesTest = %w[usersample.com, user@sample, oce]
		adressesTest.each do
			|adrr|
			invalid = User.new(@attr.merge(:email => adrr))
			invalid.should_not be_valid
		end
	end

	it "Should accept valid email adress" do
		adressesTest = %w[user@sample.com,user@samplecom.fr,usertest.test2@oce.com]
		adressesTest.each do
			|adrr|
			valid = User.new(@attr.merge(:email => adrr))
			valid.should be_valid
		end
	end

	it "email adreses should be unique" do
		User.create!(@attr)
		second_user = User.new(@attr)
		second_user.should_not be_valid
	end

	it "should reject duplicated email adreses - case insensitive" do
		up_case_email = @attr[:email].upcase
		User.create!(@attr.merge :email => up_case_email)
		second_user = User.new(@attr)
		second_user.should_not be_valid
	end

	it "should define pasword with at least 6 characters" do
		testpwd = "abcde"
		newuser = User.new(@attr.merge :pwd => testpwd, :pwd_confirmation => testpwd)
		newuser.should_not be_valid
	end

	it "should reject password not compliant with password confirmation" do
		newuser = User.new(@attr.merge :pwd_confirmation => "pwdtestbad")
		newuser.should_not be_valid
	end

	describe "password encryption" do

		before(:each) do
			@user = User.create!(@attr)
		end

		it "Should get crypted pwd attribute" do
			@user.should respond_to(:encrypted_pwd)
		end		

		it "Should contains a non empty encrypted pwd" do
			@user.encrypted_pwd.should_not be_blank
		end

		it "Should refuse pwd authentication that does not match with record" do
			res = @user.has_pwd?("InvalidPWD")
			@user.has_pwd?("InvalidPWD").should == false;
		end

		it "Should accept pwd authentication that does match with record" do
			@user.has_pwd?(@attr[:pwd]).should be true;
		end

		it "Should return authenticated user in case authentication is correct" do
			user = User.authenticate "Example@gmail.com", "testpwd"
			user.should eq(@user)
		end

		it "Should return nil user in case authentication password is NOT correct" do
			user = User.authenticate "Example@gmail.com", "testpwdNotValid"
			user.should be nil
		end

		it "Should return nil user in case authentication user email is NOT correct" do
			user = User.authenticate "unknownUser@gmail.com", "testpwd"
			user.should be nil
		end
	end
end
