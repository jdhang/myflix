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
Video.create({title: 'Futurama', description: "This is a funny show about the future!", small_cover_url: "/tmp/futurama.jpg", category: comedies})
south_park = Video.create({title: 'South Park', description: "Hilarious show!!", small_cover_url: "/tmp/south_park.jpg", category: comedies})
monk = Video.create({title: 'Monk', description: "This is a great show", small_cover_url: "/tmp/monk.jpg", category: dramas})

jason = User.create({email: "jason@example.com", password: "password", full_name: "Jason Hang"})

Review.create(rating: 5, author: jason, body: "this is a really good show", video: family_guy)
Review.create(rating: 2, author: jason, body: "this is an okay show", video: family_guy)

QueueItem.create(order: 1, user: jason, video: family_guy)
QueueItem.create(order: 2, user: jason, video: monk)
QueueItem.create(order: 3, user: jason, video: south_park)