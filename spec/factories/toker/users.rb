FactoryGirl.define do
  factory :user, class: Toker::User do |user|
    sequence(:email) { |n| "test#{n}@xample.com" }
    password "secret"
    password_confirmation "secret"
  end
end
