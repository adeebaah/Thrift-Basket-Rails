class SessionsController < ApplicationController
  def authenticated
    render json: { authenticated: user_signed_in? }
  end
end