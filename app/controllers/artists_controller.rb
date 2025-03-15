class ArtistsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  def index
    # debugger
    @artists = Artist.all.paginate(:page => params[:page], :per_page => 1)
    if current_user.admin?
      render partial: 'all_artists' , locals: { artists: @artists }
    else
      @artists
    end
  end

  def new
    @artist = Artist.new
    @user = User.new
  end
  
  def create
    debugger
    @user = User.new(users_params)
    @user.password = 'artist@123'
    @user.role = 1
    @artist = Artist.new(artist_params)
  
    respond_to do |format|
      if @user.save
        @artist.user = @user
        if @artist.save
          # debugger
          format.json { 
            render json: {
              status: :success,
              message: 'Artist created successfully'
            }
          }
        else
          # debugger
          format.json { 
            render json: {
              status: :error,
              message: @artist.errors.full_messages
            }
          }
        end
      else
        # debugger
        @artist.errors.merge!(@user.errors)
        format.json { 
          render json: {
            status: :error,
            message: @artist.errors.full_messages
          }
        }
      end
    end
  end
  

  def show
  end

  def edit
    @user = @artist.user
  end


  def update
    @user = @artist.user
    if @user.update(users_params)
      if @artist.update(artist_params)
        redirect_to artists_path, notice: 'Artist was successfully updated.'
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    if @artist.destroy
      @artist.user.destroy
      redirect_to artists_path, notice: 'Artist was successfully deleted.'
    else
      redirect_to artists_path, alert: 'Unable to delete the artist.'
    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def users_params
    params.require(:user).permit(:avatar, :name, :email, :dob)
  end

  def artist_params
    params.require(:artist).permit(:bio)
  end
end
