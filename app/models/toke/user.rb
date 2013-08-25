module Toke
  class User < ActiveRecord::Base
    has_secure_password

    def as_json
      {
        id: id,
        username: username
      }
    end
  end
end
