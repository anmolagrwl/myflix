require 'spec_helper'

describe Video do
  it { should have_many(:categories) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe "search_by_title" do
    it "returns an empty array if no videos title contain the search query" do
      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg')
      haunted_house = Video.create(title: 'Haunted House', description: 'A terrifying movie.', small_cover_url: '/tmp/haunted_house.jpg', large_cover_url: '/tmp/haunted_house_large.jpg')
      expect(Video.search_by_title("Not The Title")).to eq([])
    end

    it "returns an array of one video if a videos title is an exact match of the search query" do
      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg')
      haunted_house = Video.create(title: 'Haunted House', description: 'A terrifying movie.', small_cover_url: '/tmp/haunted_house.jpg', large_cover_url: '/tmp/haunted_house_large.jpg')
      expect(Video.search_by_title("Happy Gilmore")).to eq([happy_gilmore])
    end
    
    it "returns an array with one video if a video title contains the search query" do
      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg')
      expect(Video.search_by_title("happy")).to eq([happy_gilmore])  
    end

    it "returns an array with multiple videos if multiple videos titles contain the search query ordered by created at" do
      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 1.day.ago)
      haunted_house = Video.create(title: 'Haunted House', description: 'A terrifying movie.', small_cover_url: '/tmp/haunted_house.jpg', large_cover_url: '/tmp/haunted_house_large.jpg', created_at: 2.days.ago)
      expect(Video.search_by_title("ha")).to eq([happy_gilmore, haunted_house])
    end

    it "returns an empty array when the users search query is a blank string" do
      happy_gilmore = Video.create(title: 'Happy Gilmore', description: 'A rejected hockey player puts his skills to the golf course to save his grandmother\'s house.', small_cover_url: '/tmp/happygilmore.jpg', large_cover_url: '/tmp/happygilmore_large.jpg', created_at: 1.day.ago)
      haunted_house = Video.create(title: 'Haunted House', description: 'A terrifying movie.', small_cover_url: '/tmp/haunted_house.jpg', large_cover_url: '/tmp/haunted_house_large.jpg', created_at: 2.days.ago)
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
