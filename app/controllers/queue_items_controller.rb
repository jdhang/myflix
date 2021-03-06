class QueueItemsController < ApplicationController
  before_action :set_queue_item, only: [:destroy]
  before_action :require_user

  def index
    @queue = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    if video_in_queue?(video)
      redirect_to video, alert: "Video is already in your queue"
    else
      queue_video(video)
      redirect_to myqueue_path
    end
  end

  def update_queue
    begin
      current_user.update_queue_items(params[:queue_items])
      current_user.normalize_queue_item_position
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = "Invalid list orders entered."
    end
    redirect_to myqueue_path
  end

  def destroy
    @queue_item.destroy if current_user.queue_items.include?(@queue_item)
    current_user.normalize_queue_item_position
    redirect_to myqueue_path
  end

  private

  def set_queue_item
    @queue_item = QueueItem.find(params[:id])
  end

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def video_in_queue?(video)
    QueueItem.find_by(video: video, user: current_user)
  end

end
