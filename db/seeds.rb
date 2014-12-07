# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create({name: "Comedies"})
Category.create({name: "Action"})
Video.create({title: 'Family Guy', description: "This is a great funny show about a crazy family.", small_cover_url: "/tmp/family_guy.jpg", category_id: 1})
Video.create({title: 'Futurama', description: "This is a funny show about the future!", small_cover_url: "/tmp/futurama.jpg", category_id: 1})
Video.create({title: 'Awesome Show', description: "Hilarious show!!", small_cover_url: "/tmp/family_guy.jpg", category_id: 1})
Video.create({title: 'A great show', description: "This is a great show", small_cover_url: "/tmp/south_park.jpg", category_id: 1})
Video.create({title: 'Simpsons', description: "Funny classic show!", small_cover_url: "/tmp/futurama.jpg", category_id: 1})
Video.create({title: 'Dog Whisperer', description: "The best dog show", small_cover_url: "/tmp/family_guy.jpg", category_id: 1})
Video.create({title: 'Family Guy', description: "This is a great funny show about a crazy family.", small_cover_url: "/tmp/family_guy.jpg", category_id: 2})
Video.create({title: 'Futurama', description: "This is a funny show about the future!", small_cover_url: "/tmp/futurama.jpg", category_id: 2})
Video.create({title: 'Awesome Show', description: "Hilarious show!!", small_cover_url: "/tmp/family_guy.jpg", category_id: 2})
Video.create({title: 'A great show', description: "This is a great show", small_cover_url: "/tmp/south_park.jpg", category_id: 2})
Video.create({title: 'Simpsons', description: "Funny classic show!", small_cover_url: "/tmp/futurama.jpg", category_id: 2})
Video.create({title: 'Dog Whisperer', description: "The best dog show", small_cover_url: "/tmp/family_guy.jpg", category_id: 2})