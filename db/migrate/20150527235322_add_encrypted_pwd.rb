class AddEncryptedPwd < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_pwd, :string
  end
end
