# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :check_confirmation, only: [:create]

  # protected
  #
  # def check_confirmation
  #   user = User.find_by(email: params[:user][:email])
  #   if user && !user.confirmed?
  #     set_flash_message! :alert, :unconfirmed_account if is_navigational_format?
  #     redirect_to root_path
  #   end
  # end
end

