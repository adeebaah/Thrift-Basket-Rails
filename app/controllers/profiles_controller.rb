class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @age = calculate_age(@user.dob)
  end


  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Profile updated"
      bypass_sign_in(@user)

      redirect_to profile_path
    else
      flash[:alert] = "Profile not updated"
      redirect_to :edit

    end
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
