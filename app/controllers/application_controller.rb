require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

	around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbiddens }
      format.json { head :forbidden }
    end
  end  

  check_authorization unless: :devise_controller?
end
