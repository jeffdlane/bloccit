require 'faker'

topics = []
5.times do
  topics << Topic.create(
    name: Faker::Lorem.words(rand(1..10)).join(" "),
    description: Faker::Lorem.paragraph(rand(1..3))
    )
end
  
rand(4..10).times do
 password = Faker::Lorem.characters(10)
 u = User.new(
  name: Faker::Name.name,
  email: Faker::Internet.email,
  password: password,
  password_confirmation: password)
 u.skip_confirmation!
 u.save

  # Note: by calling `User.new` instead of `create`,
  # we create an instance of a user which isn't saved to the database.
  # The `skip_confirmation!` method sets the confirmation date
  # to avoid sending an email. The `save` method updates the database.

11.times do
  topic = topics.first
  p = u.posts.create(
    topic: topic,
    title: Faker::Lorem.words(rand(1..10)).join(" "),
    body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
  p.update_attribute(:created_at, Time.now - rand(600..31536000))
    5.times do
      c = p.comments.create(
      body:Faker::Lorem.words(rand(5..15)).join(" "))
      c.update_attribute(:user_id, u.id)
      c.save
  p.save
  # set the created_at to a time within the past year

  topics.rotate!
end
end
end

# rand(3..7).times do
#   p.comments.create(
#     body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"))

u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"