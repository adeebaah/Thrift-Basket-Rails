  require 'net/http'
  require 'uri'
  require 'json'

  class SessionsController < ApplicationController

    def facebook_callback
      access_token = params[:accessToken]
      user_id = params[:userID]
      email = params[:email]
      name = params[:name]

      existing_user = User.find_by(email: email)

      if existing_user && existing_user.provider != 'facebook'
        render json: { success: false, message: "This email is already associated with a different provider. Please log in using #{existing_user.provider.capitalize}." }
        return
      end

      user = User.find_or_create_by(email: email) do |u|
        u.name = name
        u.provider = 'facebook'
        u.uid = user_id
        u.password = Devise.friendly_token[0, 20]
        u.confirmed_at = Time.now
      end

      if user.persisted?
        sign_in(user)
        render json: { success: true }
      else
        render json: { success: false, errors: user.errors.full_messages }
      end
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


      existing_user = User.find_by(email: user_info['email'])

      if existing_user && existing_user.provider != 'google'
        provider_name = existing_user.provider.nil? ? "the original method (email/password)" : existing_user.provider.capitalize
        redirect_to new_user_registration_path, alert: "This email is already associated with #{provider_name}. Please log in using #{provider_name}."
        return
      end

      user = User.find_or_create_by(email: user_info['email']) do |u|
        u.name = user_info['name']
        u.provider = 'google'
        u.uid = user_info['id']
        u.password = Devise.friendly_token[0, 20]
        u.confirmed_at = Time.now
      end

      if user.persisted?
        sign_in(user)
        redirect_to root_path, notice: 'Signed in successfully.'
      else
        redirect_to new_user_registration_path, alert: 'Error creating user account.'
      end
    end


    def github_callback
      code = params[:code]

      if code.blank?
        redirect_to root_path, alert: 'Authorization failed. Please try again.'
        return
      end

      uri = URI('https://github.com/login/oauth/access_token')
      response = Net::HTTP.post_form(uri, {
        'code' => code,
        'client_id' => ENV['GITHUB_CLIENT_ID'],
        'client_secret' => ENV['GITHUB_CLIENT_SECRET'],
        'redirect_uri' => 'http://localhost:3000/auth/github/callback',
        'grant_type' => 'authorization_code'
      })

      body = URI.decode_www_form(response.body).to_h
      access_token = body['access_token']

      user_info_uri = URI('https://api.github.com/user')
      request = Net::HTTP::Get.new(user_info_uri)
      request['Authorization'] = "token #{access_token}"

      user_info_response = Net::HTTP.start(user_info_uri.hostname, user_info_uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      user_info = JSON.parse(user_info_response.body)

      # Check if the email exists with a different provider
      existing_user = User.find_by(email: user_info['email'])

      if existing_user && existing_user.provider != 'github'
        redirect_to new_user_registration_path, alert: "This email is already associated with a different provider. Please log in using #{existing_user.provider.capitalize}."
        return
      end

      user = User.find_or_create_by(email: user_info['email']) do |u|
        u.name = user_info['name'] || user_info['login']
        u.provider = 'github'
        u.uid = user_info['id']
        u.password = Devise.friendly_token[0, 20]
        u.confirmed_at = Time.now
      end

      if user.persisted?
        sign_in(user)
        redirect_to root_path, notice: 'Signed in successfully.'
      else
        redirect_to new_user_registration_path, alert: 'Error creating user account.'
      end
    end
  end
