module Toke
  class Token < ActiveRecord::Base
    belongs_to :user
    before_create :toke

    def expired?
      Time.now > self.expires_at
    end

    private

    def toke
      generate_token
      set_expiry
    end

    def generate_token
      self.key = SecureRandom.hex
    end

    def set_expiry(expiration = 4.hours.from_now)
      self.expires_at = expiration
    end
  end
end
