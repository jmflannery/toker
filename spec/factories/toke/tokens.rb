FactoryGirl.define do
  factory :token, class: Toke::Token do |token|
    sequence(:key) do |n|
      'x' * (32 - n.to_s.length) + n.to_s
    end
    expires_at Time.now + 4.hours
  end
end
