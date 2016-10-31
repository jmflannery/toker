module Toke
  class UserSerializer < ActiveModel::Serializer
    type :user
    attributes :id, :username
    has_one :token
  end
end
