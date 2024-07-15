class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @age = calculate_age(@user.dob)
  end


  def user_params
    params.require(:user).permit(:name, :email, :phone, :dob, :address, :password, :password_confirmation)
  end

  def calculate_age(dob)
    return if dob.blank?

    now = Time.now.utc.to_date
    now.year - dob.year - (dob.to_date.change(year: now.year) > now ? 1 : 0)
  end
end
