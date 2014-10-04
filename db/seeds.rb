# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'Drama')
Category.create(name: 'Comedy')
Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg')
Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
Video.create(title: 'Dexter', description: 'A Miami police forensics expert moonlights as a serial killer of criminals whom he believes have escaped justice.', small_cover_url: '/tmp/dexter.jpg', large_cover_url: '/tmp/dexter_large.jpg')
VideoCategory.create(video_id: 1, category_id: 2)
VideoCategory.create(video_id: 2, category_id: 2)
VideoCategory.create(video_id: 3, category_id: 1)