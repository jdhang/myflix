class QueueItemsController < ApplicationController
  before_action :set_queue_item, only: [:destroy]
  before_action :require_user

  def index
    @queue = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    
    if video_in_queue? (video)
      flash[:danger] = "Video is already in your queue"
      redirect_to video
    else
      queue_video(video)
      redirect_to myqueue_path
    end
  end

  def destroy
    @queue_item.destroy if current_user.queue_items.include?(@queue_item)
    reorder_queue_items(current_user.queue_items)
    redirect_to myqueue_path
  end

  private

  def set_queue_item
    @queue_item = QueueItem.find(params[:id])
  end

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, order: new_queue_item_order)
  end

  def new_queue_item_order
    current_user.queue_items.count + 1
  end

  def video_in_queue?(video)
    QueueItem.find_by(video: video)
  end

  def queue_item_order
    @queue_item.order
  end

  def reorder_queue_items(queue_items)
    queue_items.each do |queue_item|
      queue_item.order -= 1 if queue_item.order > queue_item_order
      queue_item.save
    end
  end

end