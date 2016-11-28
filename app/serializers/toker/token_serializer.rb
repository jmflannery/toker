module Toker
  class TokenSerializer < ActiveModel::Serializer
    attributes :id, :key, :expires_at, :user_id

    def expires_at
      object.expires_at.to_s(:db)
    end
  end
end
