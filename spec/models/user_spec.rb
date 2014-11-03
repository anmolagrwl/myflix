require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_items).order('position asc') }

  describe "#queued_video?" do
    it "returns true if the video is in the users queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_true
    end
    it "returns false if the video is not in the users queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video2)
      user.queued_video?(video).should be_false
    end
  end
end
