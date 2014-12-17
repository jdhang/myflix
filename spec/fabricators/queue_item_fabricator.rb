Fabricator(:queue_item) do
  order { (1..10).to_a.sample }
end