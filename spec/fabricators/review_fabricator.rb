Fabricator(:review) do
  rating { [1, 2, 3, 4, 5].sample }
  body { Faker::Lorem.sentences(10).join(" ") }
end