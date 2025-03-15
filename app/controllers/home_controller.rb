# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    if user_signed_in?
      render_dashboard_for_role
    else
      render :public_home
    end
  end

  def admin_dashboard
    # render layout: 'admin' # Use admin layout
  end

  def artist_dashboard
    @artist = current_user.artist_profile
    @albums = @artist.albums
    @songs = @artist.songs
  end

  def listener_dashboard
    @recent_plays = current_user.recently_played
    @recommended_songs = RecommendationService.new(current_user).generate
    @followed_artists = current_user.followed_artists
  end

  private

  def render_dashboard_for_role
    case current_user.role
    when 'admin'
      redirect_to admin_root_path # Redirect to admin namespace
    when 'artist'
      redirect_to artist_dashboard_path
    when 'listener'
      redirect_to listener_dashboard_path
    else
      redirect_to root_path
    end
  end
end
