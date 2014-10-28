require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title) 
    end
  end

  describe "#video_category" do
    it "returns nil if the video has no category" do
      video = Fabricate(:video) 
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_category).to eq(nil)
    end

    it "returns the category of the associated video" do
      category = Fabricate(:category, name: "comedy")
      video = Fabricate(:video, categories: [category])
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_category).to eq("comedy")
    end

    it "returns the multiple categories from the associated video" do
      category1 = Fabricate(:category, name: "comedy")
      category2 = Fabricate(:category, name: "drama")
      video = Fabricate(:video, categories: [category1, category2])
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_category).to eq("comedy, drama")
    end
  end

  describe "#rating" do
    it "returns the rating of the exiting review associated with the video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if the review doesn't exist" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    it "changes the rating of an existing review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    it "clears the rating of an existing review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "creates a review with the rating if no review exists" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end
end
