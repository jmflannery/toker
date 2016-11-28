require 'rails_helper'

module Toker

  describe User do

    let(:user_attrs) { FactoryGirl.attributes_for(:user) }
    subject { User.new(user_attrs) }

    it "has a valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a email" do
      user = FactoryGirl.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email].size).to be >= 1
    end

    it "is invalid with a duplicate email" do
      FactoryGirl.create(:user, email: 'fred@yo.net')
      user = FactoryGirl.build(:user, email: 'fred@yo.net')
      user.valid?
      expect(user.errors[:email].size).to be >= 1
    end

    it "is invalid without a password" do
      user = FactoryGirl.build(:user, password: nil)
      user.valid?
      expect(user.errors[:password].size).to be >= 1
    end

    it "is invalid without a password_confirmation" do
      user = FactoryGirl.build(:user, password: 'secret', password_confirmation: nil)
      user.valid?
      expect(user.errors[:password_confirmation].size).to be >= 1
    end

    it "is invalid if password_confirmation doesn't match password" do
      user = FactoryGirl.build(:user, password_confirmation: "wrong")
      user.valid?
      expect(user.errors[:password_confirmation].size).to be >= 1
    end

    it "is invalid with a short password under 6 chars" do
      user = FactoryGirl.build(:user, password: "lesss", password_confirmation: "lesss")
      user.valid?
      expect(user.errors[:password].size).to be >= 1
    end

    it "is invalid with a long password over 50 chars" do
      tolong = 's' * 51
      user = FactoryGirl.build(:user, password: tolong, password_confirmation: tolong)
      user.valid?
      expect(user.errors[:password].size).to be >= 1
    end
  end
end
