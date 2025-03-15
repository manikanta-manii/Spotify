class Admin::DashboardController < ApplicationController
  layout 'admin_dashboard'
  
  def index
    @current_tab = params[:tab] || 'artists' # Default tab
    @current_tab_partial = "admin/dashboard/manage_tabs/#{@current_tab}"
  end
end
