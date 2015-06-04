require 'faker'

namespace :db do
  desc "Peupler la base de données"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Utilisateur exemple",
                 :email => "example@railstutorial.org",
                 :pwd => "foobar",
                 :pwd_confirmation => "foobar")
    99.times do |n|
      nom  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "motdepasse"
      User.create!(:name => nom,
                   :email => email,
                   :pwd => password,
                   :pwd_confirmation => password)
    end
  end
end