class VideosController < ApplicationController
  before_action :set_video, except: [:index, :new, :create]

  def index
    @categories = Category.all
  end

  def show
  end

  def new

  end

  def create

  end

  def edit
  end

  def update
  
  end

  def destroy

  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
    end

    def set_video
      @video = Video.find(params[:id])
    end

end