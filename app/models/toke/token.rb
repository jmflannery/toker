module Toke
  class Token < ActiveRecord::Base
    belongs_to :user
    before_create :generate_token, :set_expiry

    private

    def generate_token
      self.key = SecureRandom.hex
    end

    def set_expiry
      self.expires_at = 4.hours.from_now
    end
  end
end
