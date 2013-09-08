FactoryGirl.define do
  factory :user, class: Toke::User do |user|
    sequence(:username) { |n| "User#{n}" }
    password "secret"
    password_confirmation "secret"
  end
end
