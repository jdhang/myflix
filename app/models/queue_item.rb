class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(author: user.id, video_id: video.id).first

    review.rating if review
  end

  def category_name
    video.category.name
  end

end