class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  before_action :set_main_categories

  skip_before_action :verify_authenticity_token, if: :omniauth_callback?

  private

  def omniauth_callback?
    devise_controller? && request.env['omniauth.auth'].present?
  end

  private
  def set_main_categories
    @main_categories = Category.all
  end
end
