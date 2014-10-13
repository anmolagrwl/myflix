Fabricator(:review) do
  video
  user
  description { Faker::Lorem.paragraph }
  rating { (1..5).to_a.sample }
end
