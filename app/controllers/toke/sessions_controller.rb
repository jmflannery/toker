module Toke
  class SessionsController < ApplicationController
    before_action :toke!, only: :destroy

    def create
      @user = authenticate_with_http_basic do |email, password|
        user = User.find_by email: email
        if user && user.authenticate(password)
          user.token.destroy if user.token
          user.token = Token.create expires_at: 1.year.from_now
          user.token.generate_key!
          user.token.save
          user
        end
      end
      if @user
        response.headers['Authorization'] = "Token #{@user.token.key}"
        render json: @user, status: :created
      else
        render json: { Unauthorized: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def update
      token = authenticate_with_http_token do |jwt, options|
        Token.decode(jwt)[0]
      end
      user = token.user if token
      if user
        response.headers['Authorization'] = "Token #{token.key}"
        render json: user
      else
        render json: { Unauthorized: 'Invalid session' }, status: :unauthorized
      end
    end

    def destroy
      @user.token.destroy
      head :no_content
    end

    private

    def payload
      {
        user_id: @user.id,
        exp: 1.year.from_now.to_i
      }
    end
  end
end
