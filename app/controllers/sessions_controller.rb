  require 'net/http'
  require 'uri'
  require 'json'

  class SessionsController < ApplicationController

    def new
      @google_client_id = ENV['GOOGLE_CLIENT_ID']
    end

    def google_callback
      code = params[:code]

      uri = URI('https://oauth2.googleapis.com/token')
      response = Net::HTTP.post_form(uri, {
        'code' => code,
        'client_id' => ENV['GOOGLE_CLIENT_ID'],
        'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
        'redirect_uri' => 'http://localhost:3000/auth/google_oauth2/callback',
        'grant_type' => 'authorization_code'
      })

      body = JSON.parse(response.body)
      access_token = body['access_token']

      user_info_uri = URI('https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      request = Net::HTTP::Get.new(user_info_uri)
      request['Authorization'] = "Bearer #{access_token}"

      user_info_response = Net::HTTP.start(user_info_uri.hostname, user_info_uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      user_info = JSON.parse(user_info_response.body)


      logger.debug "Google user info: #{user_info.inspect}"

      user = User.find_or_create_by(email: user_info['email']) do |u|
        u.name = user_info['name']
        u.provider = 'google'
        u.uid = user_info['id']
        u.password = Devise.friendly_token[0, 20]
        u.confirmed_at = Time.now
      end

      if user.persisted?
        logger.debug "User successfully created or found: #{user.inspect}"
        sign_in(user)
        redirect_to root_path, notice: 'Signed in successfully.'
      else
        logger.debug "User creation failed: #{user.errors.full_messages}"
        redirect_to new_user_registration_path, alert: 'Error creating user account.'
      end
    end
  def authenticated
    render json: { authenticated: user_signed_in? }
  end

  end



