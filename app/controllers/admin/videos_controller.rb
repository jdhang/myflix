class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    binding.pry
    @video = Video.new(video_params)
    if @video.save
      flash[:notice] = "You have successfully added the video '#{@video.title}'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video. Please check the errors."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end

end
