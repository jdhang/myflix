Fabricator(:following) do
  user_id { Fabricate(:user).id }
end
