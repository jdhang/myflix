# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
comedies = Category.create({name: "Comedies"})
dramas = Category.create({name: "Dramas"})
family_guy = Video.create({title: 'Family Guy', description: "This is a great funny show about a crazy family.", small_cover_url: "/tmp/family_guy.jpg", category: comedies})
futurama = Video.create({title: 'Futurama', description: "This is a funny show about the future!", small_cover_url: "/tmp/futurama.jpg", category: comedies})
south_park = Video.create({title: 'South Park', description: "Hilarious show!!", small_cover_url: "/tmp/south_park.jpg", category: comedies})
monk = Video.create({title: 'Monk', description: "This is a great show", small_cover_url: "/tmp/monk.jpg", category: dramas})

jason = User.create({email: "jason@example.com", password: "password", full_name: "Jason Hang", admin: true})
bob = User.create({email: "bob@example.com", password: "password", full_name: "Bob Bobby"})
alice = User.create({email: "alice@example.com", password: "password", full_name: "Alice Wonder"})
jon = User.create({email: "jon@example.com", password: "password", full_name: "Jon Jonny"})
joe = User.create({email: "joe@example.com", password: "password", full_name: "Joe Joey"})

Review.create(rating: 5, author: jason, body: "this is a really good show", video: family_guy)
Review.create(rating: 4, author: jason, body: "this is a really good show", video: monk)
Review.create(rating: 3, author: jason, body: "this is a really good show", video: south_park)
Review.create(rating: 4, author: jason, body: "this is a really good show", video: futurama)
Review.create(rating: 5, author: bob, body: "this is a really good show", video: family_guy)
Review.create(rating: 4, author: bob, body: "this is a really good show", video: monk)
Review.create(rating: 3, author: bob, body: "this is a really good show", video: south_park)
Review.create(rating: 4, author: bob, body: "this is a really good show", video: futurama)
Review.create(rating: 5, author: alice, body: "this is a really good show", video: family_guy)
Review.create(rating: 4, author: alice, body: "this is a really good show", video: monk)
Review.create(rating: 3, author: alice, body: "this is a really good show", video: south_park)
Review.create(rating: 4, author: alice, body: "this is a really good show", video: futurama)
Review.create(rating: 5, author: jon, body: "this is a really good show", video: family_guy)
Review.create(rating: 4, author: jon, body: "this is a really good show", video: monk)
Review.create(rating: 3, author: jon, body: "this is a really good show", video: south_park)
Review.create(rating: 4, author: jon, body: "this is a really good show", video: futurama)
Review.create(rating: 5, author: joe, body: "this is a really good show", video: family_guy)
Review.create(rating: 4, author: joe, body: "this is a really good show", video: monk)
Review.create(rating: 3, author: joe, body: "this is a really good show", video: south_park)
Review.create(rating: 4, author: joe, body: "this is a really good show", video: futurama)

[jason, bob, alice, jon, joe].each do |user|
  QueueItem.create(position: 1, user: user, video: family_guy)
  QueueItem.create(position: 2, user: user, video: monk)
  QueueItem.create(position: 3, user: user, video: south_park)
  QueueItem.create(position: 4, user: user, video: futurama)
end

Following.create(user_id: bob.id, follower_id: jason.id)
Following.create(user_id: alice.id, follower_id: jason.id)
Following.create(user_id: joe.id, follower_id: jason.id)
Following.create(user_id: jon.id, follower_id: jason.id)
Following.create(user_id: jason.id, follower_id: jon.id)
Following.create(user_id: jason.id, follower_id: joe.id)
Following.create(user_id: jason.id, follower_id: bob.id)
Following.create(user_id: jason.id, follower_id: alice.id)
