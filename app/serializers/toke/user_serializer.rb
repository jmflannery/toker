module Toke
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end
end
