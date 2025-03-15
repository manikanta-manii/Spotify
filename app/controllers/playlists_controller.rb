class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  def index
    @playlists = current_user.playlists
  end

  def show
    # @playlist is already set by before_action
  end

  def new
    @playlist = current_user.playlists.build
  end

  def create
    # debugger
    @playlist = current_user.playlists.build(playlist_params)

    if @playlist.save
      redirect_to root_path, notice: 'Playlist was successfully created.'
    else
      render :new , status: :unprocessable_entity
    end
  end

  def edit
    # @playlist is already set by before_action
  end

  def update
    if @playlist.update(playlist_params)
      redirect_to root_path, notice: 'Playlist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @playlist.destroy
      redirect_to root_path, notice: 'Playlist was successfully deleted.'
    else
      redirect_to root_path, alert: 'Failed to delete playlist.'
    end
  end

  def add_song
    debugger
    # song = Song.find(params[:song_id])
    
    # if @playlist.songs << song
    #   redirect_to @playlist, notice: 'Song was successfully added to playlist.'
    # else
    #   redirect_to @playlist, alert: 'Failed to add song to playlist.'
    # end
  end

  def remove_song
    # song = Song.find(params[:song_id])
    
    # if @playlist.songs.delete(song)
    #   redirect_to @playlist, notice: 'Song was successfully removed from playlist.'
    # else
    #   redirect_to @playlist, alert: 'Failed to remove song from playlist.'
    # end
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:name, :description)
  end
end
