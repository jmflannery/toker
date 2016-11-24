module Toke
  class User < ActiveRecord::Base
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password, confirmation: true, length: { in: 6..50 }
    validates :password_confirmation, presence: true

    has_one :token
  end
end
