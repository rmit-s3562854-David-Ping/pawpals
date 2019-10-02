# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a sample user.
User.create!(name:  "Hoid Lightsong",
             email: "stormlight@mail.com",
             password:              "Password@9",
             password_confirmation: "Password@9",
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "John Doe",
             email: "test@mail.com",
             password:              "Password@9",
             password_confirmation: "Password@9",
             activated: true,
             activated_at: Time.zone.now)

# Generate example users using faker gem
10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@test.org"
  password = "Password@9"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate posts some users
users = User.order(:created_at).take(5)
5.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end