class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  private

  def video_params
    params.require(:video).permit(:title, :category, :description)
  end

end
