module Toke
  class Token < ActiveRecord::Base
    belongs_to :user
    before_create :expire

    def toke
      generate_token
      set_expiry
      save
    end

    private

    def expire
      self.expires_at = Time.now
      self.key = nil
    end

    def generate_token
      self.key = SecureRandom.hex
    end

    def set_expiry(expiration = 4.hours.from_now)
      self.expires_at = expiration
    end
  end
end
