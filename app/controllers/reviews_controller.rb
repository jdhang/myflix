class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params)
    @review.author = current_user

    if @review.save
      flash[:success] = "Your review was successfully submitted."
      redirect_to @video
    else
      render 'videos/show'
    end

  end

  private
    def review_params
      params.require(:review).permit!
    end


end