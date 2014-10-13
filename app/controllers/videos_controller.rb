class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  before_action :require_user
  
  def index
    @categories = Category.all
  end

  def show
    @reviews = @video.reviews
  end

  def search
    @video_search_results = Video.search_by_title(params[:query])
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end
end
