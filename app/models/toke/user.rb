module Toke
  class User < ActiveRecord::Base
    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :password, confirmation: true, length: { in: 6..50 }
    validates :password_confirmation, presence: true

    has_one :token

    def toke
      create_token
    end
  end
end
