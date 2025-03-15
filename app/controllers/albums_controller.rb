class AlbumsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  def index
    @albums = Album.all
  end

  def show
  end

  def new
    @album = Album.new
  end

  def edit
  end

  def create
    @album = Album.new(album_params)

      if @album.save
        # Process songs and their metadata
        if params[:song][:audio_file].present?
          audio_files = params[:song][:audio_file].reject(&:blank?)
          audio_files.each_with_index do |audio_file, index|
            # Get metadata for this song
            metadata = params[:songs_metadata][index.to_s]
            # Create the song
            song = @album.songs.build(
              name: metadata[:name],
              audio_file: audio_file
            )

            # Associate artists with the song
            if metadata[:artist_ids].present?
              song.artists = Artist.find(metadata[:artist_ids])
            end

            unless song.save
              render :new , status: :unprocessable_entity
            end
          end
        end
        redirect_to albums_path , notice: 'Album created succesfully'
      else
        render :new , status: :unprocessable_entity
      end
  end

  def update
    if @album.update(album_params)
      redirect_to albums_path, notice: 'Album was successfully updated.'
    else
      render :edit  , status: :unprocessable_entity
    end
  end

  def destroy
    if @album.destroy
      redirect_to albums_path, notice: 'Album was successfully deleted.'
    else
      redirect_to albums_path, alert: 'Unable to delete the Album.'
    end
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:cover_image , :name, :released_date, :description, :artist_id)
  end
end
