class HomeController < ApplicationController
  def index
    if user_signed_in?
      render_dashboard_for_role
    else
      render :public_home
    end
  end

  private

  def render_dashboard_for_role
    case current_user.role
    when 'admin'
      render :admin_dashboard
    when 'artist'
      render :artist_dashboard
    when 'listener'
      render :listener_dashboard
    end
  end

end
