require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:name)}

  describe "recent videos" do
    
    it "returns an empty array of videos if there are no videos in the category" do
      comedy = Category.create(name: 'Comedy')
      drama = Category.create(name: 'Drama')

      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year\'s Eve 2999.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', created_at: 3.days.ago)
      simpsons = Video.create(title: 'The Simpsons', description: 'The satiric adventures of a working-class family in the misfit city of Springfield.', small_cover_url: '/tmp/simpsons.jpg', large_cover_url: '/tmp/simpsons_large.jpg', created_at: 1.days.ago)
      psych = Video.create(title: 'Psych', description: 'A novice sleuth is hired by the police after he cons them into thinking he has psychic powers that help solve crimes.', small_cover_url: '/tmp/psych.jpg', large_cover_url: '/tmp/psych_large.jpg', created_at: 11.days.ago)
      monk = Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk.jpg', created_at: 4.days.ago)
      
      VideoCategory.create(video_id: 1, category_id: 1)
      VideoCategory.create(video_id: 2, category_id: 1)
      VideoCategory.create(video_id: 3, category_id: 1)
      VideoCategory.create(video_id: 4, category_id: 1)
      VideoCategory.create(video_id: 5, category_id: 1)
      
      expect(Category.recent_videos(drama)).to eq([])
    end

    it "returns an array of more than one but less than six videos if there are not six videos in the category in descending order" do
      comedy = Category.create(name: 'Comedy')

      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year\'s Eve 2999.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', created_at: 3.days.ago)
      simpsons = Video.create(title: 'The Simpsons', description: 'The satiric adventures of a working-class family in the misfit city of Springfield.', small_cover_url: '/tmp/simpsons.jpg', large_cover_url: '/tmp/simpsons_large.jpg', created_at: 1.days.ago)
      psych = Video.create(title: 'Psych', description: 'A novice sleuth is hired by the police after he cons them into thinking he has psychic powers that help solve crimes.', small_cover_url: '/tmp/psych.jpg', large_cover_url: '/tmp/psych_large.jpg', created_at: 11.days.ago)
      monk = Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk.jpg', created_at: 4.days.ago)
      
      VideoCategory.create(video_id: 1, category_id: 1)
      VideoCategory.create(video_id: 2, category_id: 1)
      VideoCategory.create(video_id: 3, category_id: 1)
      VideoCategory.create(video_id: 4, category_id: 1)
      VideoCategory.create(video_id: 5, category_id: 1)
      
      expect(Category.recent_videos(comedy)).to eq([simpsons, happy_gilmore, futurama, monk, psych])
    end

    it "returns an array of six videos if there are six in the category in descending order" do
      comedy = Category.create(name: 'Comedy')

      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year\'s Eve 2999.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', created_at: 3.days.ago)
      simpsons = Video.create(title: 'The Simpsons', description: 'The satiric adventures of a working-class family in the misfit city of Springfield.', small_cover_url: '/tmp/simpsons.jpg', large_cover_url: '/tmp/simpsons_large.jpg', created_at: 1.days.ago)
      psych = Video.create(title: 'Psych', description: 'A novice sleuth is hired by the police after he cons them into thinking he has psychic powers that help solve crimes.', small_cover_url: '/tmp/psych.jpg', large_cover_url: '/tmp/psych_large.jpg', created_at: 11.days.ago)
      monk = Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk.jpg', created_at: 4.days.ago)
      family_guy = Video.create(title: 'Family Guy', description: 'In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg', created_at: 2.days.ago)
      
      VideoCategory.create(video_id: 1, category_id: 1)
      VideoCategory.create(video_id: 2, category_id: 1)
      VideoCategory.create(video_id: 3, category_id: 1)
      VideoCategory.create(video_id: 4, category_id: 1)
      VideoCategory.create(video_id: 5, category_id: 1)
      VideoCategory.create(video_id: 6, category_id: 1)
      
      expect(Category.recent_videos(comedy)).to eq([simpsons, family_guy, happy_gilmore, futurama, monk, psych])
    end

    it "returns an array of six videos if there are more than six in the category in descending order" do
      comedy = Category.create(name: 'Comedy')

      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year\'s Eve 2999.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', created_at: 3.days.ago)
      simpsons = Video.create(title: 'The Simpsons', description: 'The satiric adventures of a working-class family in the misfit city of Springfield.', small_cover_url: '/tmp/simpsons.jpg', large_cover_url: '/tmp/simpsons_large.jpg', created_at: 1.days.ago)
      psych = Video.create(title: 'Psych', description: 'A novice sleuth is hired by the police after he cons them into thinking he has psychic powers that help solve crimes.', small_cover_url: '/tmp/psych.jpg', large_cover_url: '/tmp/psych_large.jpg', created_at: 11.days.ago)
      monk = Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk.jpg', created_at: 4.days.ago)
      modern_family = Video.create(title: 'Modern Family', description: 'Three different, but related families face trials and tribulations in their own uniquely comedic ways.', small_cover_url: '/tmp/modern_family.jpg', large_cover_url: '/tmp/modern_family.jpg', created_at: 1.days.ago)
      family_guy = Video.create(title: 'Family Guy', description: 'In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg', created_at: 2.days.ago)
      
      VideoCategory.create(video_id: 1, category_id: 1)
      VideoCategory.create(video_id: 2, category_id: 1)
      VideoCategory.create(video_id: 3, category_id: 1)
      VideoCategory.create(video_id: 4, category_id: 1)
      VideoCategory.create(video_id: 5, category_id: 1)
      VideoCategory.create(video_id: 6, category_id: 1)
      VideoCategory.create(video_id: 7, category_id: 1)
      
      expect(Category.recent_videos(comedy)).to eq([modern_family, simpsons, family_guy, happy_gilmore, futurama, monk])
    end

  end
end