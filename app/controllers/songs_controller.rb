class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song, only: [ :destroy , :edit , :update]

  def index
    @songs = Song.all
  end

  def new
    @song = Song.new
  end
  
  def create
    @album = Album.find(params[:song][:album_id].to_i)
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
    redirect_to albums_path , notice: 'Song Added succesfully'
  end

  def show
  end

  def edit
    
  end


  def update
    # debugger
    if @song.update(song_params)
      # Clear existing associations
      @song.song_artists.destroy_all
      
      # Create new associations
      if params[:song][:artist_ids].present?
        params[:song][:artist_ids].each do |artist_id|
          @song.song_artists.create(artist_id: artist_id)
        end
      end
      
      redirect_to songs_path , notice: 'Song updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @song.destroy
       redirect_to songs_path , notice: 'Song Deleted succesfully'
    else
       redirect_to songs_path , notice: 'Song Deletion Failed'
    end
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:name , :audio_file , :album_id )
  end

end
