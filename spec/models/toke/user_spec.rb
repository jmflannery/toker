require 'rails_helper'

module Toke

  describe User do

    let(:user_attrs) { FactoryGirl.attributes_for(:user) }
    subject { User.new(user_attrs) }

    it "has a valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a username" do
      user = FactoryGirl.build(:user, username: nil)
      user.valid?
      expect(user.errors[:username].size).to be >= 1
    end

    it "is invalid with a duplicate username" do
      FactoryGirl.create(:user, username: 'fred')
      user = FactoryGirl.build(:user, username: 'fred')
      user.valid?
      expect(user.errors[:username].size).to be >= 1
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

    it "has a nil token initially" do
      expect(subject.token).to be_nil
    end

    it "generates a token with 32 digit key" do
      subject.save
      subject.toke
      expect(subject.reload.token.key).to match /\S{32}/      
    end
  end
end
