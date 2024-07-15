class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end
  def checkout_details
    @user = current_user
  end

end