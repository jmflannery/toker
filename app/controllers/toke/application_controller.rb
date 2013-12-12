module Toke
  class ApplicationController < ActionController::Base

    def toke
      head :unauthorized unless current_user
    end

    def current_user
      token = Token.active.where(key: toke_key).first
      token.user if token
    end

    def toke_key
      request.headers['X-Toke-Key']
    end
  end
end
