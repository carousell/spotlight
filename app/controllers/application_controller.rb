class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :dashboard_home_path

  def default_dashboard
    Dashboard.first || Dashboard.create(title: 'Default Dashboard')
  end

  def dashboard_home_path
    ENV['WEB_HOST'] || dashboards_path
  end
end
