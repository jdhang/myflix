class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }, dependent: :destroy
  has_many :queue_items

  validates_presence_of :title, :description

  def self.search_by_title (title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%").order("created_at DESC")
  end

  def rating
    no_reviews? ? "No ratings yet" : "#{average_rating}/5.0"
  end

  private

  def average_rating
    sum = 0
    reviews.each do |review|
      sum += review.rating
    end
    sum.to_f / reviews.count
  end

  def no_reviews?
    reviews.count == 0
  end

end