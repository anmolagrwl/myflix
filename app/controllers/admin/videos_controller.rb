class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)    

    if @video.save
      flash[:success] = "Video #{@video.title} added."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "There was an issue with your video."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit!
  end
end