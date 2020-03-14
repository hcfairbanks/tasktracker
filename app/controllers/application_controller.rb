class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale, :current_user, :logged_in?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  private

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = cookies[:locale].blank? ? params[:locale] : cookies[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    true if session[:user_id]
  end

  helper_method :current_user
  helper_method :logged_in?
end
