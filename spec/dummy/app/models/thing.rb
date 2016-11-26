class Thing < ActiveRecord::Base
  scope :published, -> { where published: true }
end
