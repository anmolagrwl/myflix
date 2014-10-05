class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  
  def index
    @categories = Category.all
  end

  def show
  end

  def search
    @video_search_results = Video.search_by_title(params[:query])
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  # def video_params
  #   params.require(:video).permit()
  # end

end
