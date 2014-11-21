require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_items).order('position asc') }
  it { should have_many(:reviews).order('created_at desc') }

  describe "#queued_video?" do
    it "returns true if the video is in the users queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy
    end
    it "returns false if the video is not in the users queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video2)
      user.queued_video?(video).should be_falsy
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be_truthy
    end
    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.follows?(bob)).to be_falsy
    end
  end
end
