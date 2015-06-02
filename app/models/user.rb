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

require 'digest'

class User < ActiveRecord::Base

	attr_accessor :pwd

	email_regex = /\b[\w+\-.]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

	validates :name, :email,  :presence => true

	validates :name, :length => {:maximum=> 25}

	validates :email, :format => { :with => email_regex}, :uniqueness => { :case_sensitive => false }

	validates :pwd, :confirmation => true,
					:presence => true,
					:length => { :within => 6..40 }

	before_save :encrypt_pwd


	# Check wether submited password is compliant with saved password for this user.
	def has_pwd?(input_pwd)
		encrypted_pwd == encrypt(input_pwd);
	end

	# Try to authenticate user with given credentials. Retunr nil if credentials are invalid
	def self.authenticate(input_email, input_pwd)
		user = self.find_by_email input_email
		unless user.nil?
			return user if user.has_pwd? input_pwd
		end
	end

	def self.authenticate_with_salt(id, cookie_salt)
	    user = find_by_id(id)
	    (user && user.salt == cookie_salt) ? user : nil
  	end

	private 

		def encrypt_pwd
			self.salt = make_salt if new_record?
			self.encrypted_pwd = encrypt(pwd)
		end

		def encrypt(inputStr)
			secure_hash("#{salt}--#{inputStr}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{pwd}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end

end
