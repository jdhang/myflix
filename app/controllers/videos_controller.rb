class VideosController < AuthenticatesController
  before_action :set_video, except: [:index, :new, :create, :search]

  def index
    @categories = Category.all
  end

  def show
    @review = Review.new
    @reviews = @video.reviews
  end

  def search
    @search_results = Video.search_by_title(params[:search_terms])
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end

  def set_video
    @video = Video.find(params[:id])
  end

end
