class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :author, class_name: User, foreign_key: :user_id

  attr_accessor :skip_validation

  validates_presence_of :rating, :body, :author, unless: :skip_validation
end