class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]

  def index
    @pictures = Picture.all
  end

  def show
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def create
    # @picture = Picture.new(picture_params)
    # @picture[:user_id] = session[:user_id]
    @picture = current_user.pictures.build(picture_params)
    
    respond_to do |format|
      if @picture.save
        format.html { redirect_to picture_url(@picture), notice: "投稿しました！" }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm 
    @picture = Picture.new(picture_params)
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  def edit
  end

  # def create
  #   # @picture = Picture.new(picture_params)
  #   # @picture[:user_id] = session[:user_id]
  #   @picture = current_user.pictures.build(picture_params)
    
  #   respond_to do |format|
  #     if @picture.save
  #       format.html { redirect_to picture_url(@picture), notice: "投稿しました！" }
  #       format.json { render :show, status: :created, location: @picture }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @picture.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "更新しました！" }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
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

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(:image, :image_cache, :content)
  end
end 
