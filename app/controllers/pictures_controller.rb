class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]
  before_action :ensure_user, only: %i[ edit update destroy ]

  def index
    @pictures = Picture.all
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def create
    @picture = current_user.pictures.build(picture_params)
      if @picture.save
        ContactMailer.contact_mail(@picture).deliver
        redirect_to pictures_path, notice: "投稿しました！" 
      else
        render :new
      end
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice: "更新しました！" 
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: "削除しました！" }
      format.json { head :no_content }
    end
  end

  private

  def ensure_user
    @pictures = current_user.pictures
    @picture = @pictures.find_by(id: params[:id])
    redirect_to new_session_path unless @picture
  end

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(:image, :image_cache, :content)
  end
end 
