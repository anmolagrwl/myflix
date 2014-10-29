class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :categories, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, {only_integer: true}

  def video_category
    if categories.any?
      categories.map(&:name).join(", ") 
    else
      nil
    end
  end
  
  def rating=(new_rating)    
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.create(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end
  
  def rating
    review.rating if review
  end

  def review
    @review || Review.where(user_id: user.id, video_id: video.id).first
  end

end
