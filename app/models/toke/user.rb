module Toke
  class User < ActiveRecord::Base
    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :password, length: { in: 6..50 }

    has_one :token

    def toke
      create_token
    end
  end
end
