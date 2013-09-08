module Toke
  class User < ActiveRecord::Base
    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :password, length: { in: 6..50 }

    has_one :token

    after_create :generate_token

    private

    def generate_token
      create_token
    end
  end
end
