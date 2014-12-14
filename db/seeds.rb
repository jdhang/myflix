# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
comedies = Category.create({name: "Comedies"})
dramas = Category.create({name: "Dramas"})
Video.create({title: 'Family Guy', description: "This is a great funny show about a crazy family.", small_cover_url: "/tmp/family_guy.jpg", category: comedies})
Video.create({title: 'Futurama', description: "This is a funny show about the future!", small_cover_url: "/tmp/futurama.jpg", category: comedies})
Video.create({title: 'South Park', description: "Hilarious show!!", small_cover_url: "/tmp/south_park.jpg", category: comedies})
Video.create({title: 'Monk', description: "This is a great show", small_cover_url: "/tmp/monk.jpg", category: dramas})

User.create({email: "jason@example.com", password: "password", full_name: "Jason Hang"})