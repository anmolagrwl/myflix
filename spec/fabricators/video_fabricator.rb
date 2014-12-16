Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.sentence }
  url { Faker::Internet.url }
end