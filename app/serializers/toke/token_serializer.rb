module Toke
  class TokenSerializer < ActiveModel::Serializer
    attributes :id, :key, :expires_at

    def expires_at
      object.expires_at.to_s(:db)
    end
  end
end
