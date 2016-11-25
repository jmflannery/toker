require "toke/engine"
require "active_model_serializers"
require "jwt"

module Toke
  module TokenAuthentication
    include ActionController::HttpAuthentication::Token::ControllerMethods

    def toke!
      token = authenticate_with_http_token do |jwt, options|
        token, error = Token.decode(jwt)
        errors.merge!(error) if error
        token
      end
      @user = token.user if token
      render json: errors, status: :unauthorized unless @user
    end

    def current_user
      @user
    end

    private

    def errors
      @errors ||= {}
    end
  end
end
