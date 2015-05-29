FactoryGirl.define do 

	factory :user do |user|
		user.name	"Gilles Monnier"
		user.email	"gilles@yahoo.fr"
		user.pwd	"pwdfromfactory"
		user.pwd_confirmation	"pwdfromfactory"
	end
	
end