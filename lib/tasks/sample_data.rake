namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create(:name => "amdin",
                      :email => 'wangjiwen10@gmail.org',
                      :password => "123456",
                      :password_confirmation => "123456")
  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
  # for heroku
  User.create(:name => "Andy Effort",
              :email => 'outofclouds@gmail.org',
              :password => "123456",
              :password_confirmation => "123456")
end

def make_microposts
  50.times do
    User.all(:limit => 6).each do |user|
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = User.first
  following = users[1..50]
  followers = users[3..40]
  following.each {|followed| user.follow!(followed) }
  followers.each {|follower| follower.follow!(user)}
end