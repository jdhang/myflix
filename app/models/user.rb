class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> {order :position}
  
  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  def update_queue_items(new_queue_items)
    ActiveRecord::Base.transaction do
      new_queue_items.each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update!(position: queue_item_data["position"])
        if !input_rating_empty?(queue_item_data["rating"])
          if queue_item.rating 
            update_queue_item_rating(queue_item, queue_item_data["rating"])
          else
            new_queue_item_review(queue_item, queue_item_data["rating"])
          end
        end
      end
    end
  end

  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  private

  def new_queue_item_review(queue_item, rating)
    queue_item.video.reviews.create!(skip_validation: true, rating: rating, author: queue_item.user)
  end

  def update_queue_item_rating(queue_item, rating)
    queue_item.video.reviews.where(author: queue_item.user).first.update!(skip_validation: true, rating: rating)
  end

  def input_rating_empty?(rating)
    rating == ""
  end

end