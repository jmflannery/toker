module Toker
  class Token < ActiveRecord::Base
    belongs_to :user

    def generate_key!
      self.key = JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
      return self.key
    end

    def payload
      {
        token_id: id,
        exp: expires_at.to_i
      }
    end

    def self.decode(jwt)
      begin
        decoded_token = JWT.decode jwt, Rails.application.secrets.secret_key_base, 'HS256'
        token_id = decoded_token[0]['token_id']
        token = Token.find(token_id)
      rescue JWT::ExpiredSignature
        error = { Unauthorized: 'Token expired' }
      rescue JWT::DecodeError, JWT::VerificationError, ActiveRecord::RecordNotFound
        error = { Unauthorized: 'Token invalid' }
      end
      [token, error]
    end
  end
end
