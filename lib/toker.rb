require "toker/engine"
require "active_model_serializers"
require "jwt"

module Toker
  module TokenAuthentication
    include ActionController::HttpAuthentication::Token::ControllerMethods

    def toke!(&unauthorized_handler)
      token = authenticate_with_http_token do |jwt, options|
        token, error = Token.decode(jwt)
        errors.merge!(error) if error
        token
      end

      @user = token.user if token

      unless @user
        if block_given?
          unauthorized_handler.call(errors)
        else
          render json: errors, status: :unauthorized
        end
      end
    end

    def current_user
      @user
    end

    private

    def errors
      @errors ||= { 'Unauthorized' => 'Token required' }
    end
  end
end
