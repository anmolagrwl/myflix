class Category < ActiveRecord::Base
  has_many :video_categories
  has_many :videos, through: :video_categories

  validates_presence_of :name

  def self.recent_videos(category)
    category.videos.limit(6).order("created_at DESC")
  end
end