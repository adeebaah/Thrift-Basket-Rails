class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :dob, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone, :dob, :address])
  end
end
