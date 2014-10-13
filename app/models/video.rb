class Video < ActiveRecord::Base
  has_many :video_categories
  has_many :categories, through: :video_categories
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(query)
    return [] if query.blank?
    where("title LIKE ?", "%#{query}%").order("created_at DESC")
  end
end
