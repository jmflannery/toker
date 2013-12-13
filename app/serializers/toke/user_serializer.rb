module Toke
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
    has_one :token
  end
end
