require 'spec_helper'

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
      expect(FactoryGirl.build(:user, username: nil)).to have(1).errors_on(:username)
    end

    it "is invalid with a duplicate username" do
      FactoryGirl.create(:user, username: 'fred')
      expect(FactoryGirl.build(:user, username: 'fred')).to have(1).errors_on(:username)
    end

    it "is invalid without a password" do
      expect(FactoryGirl.build(:user, password: nil)).to have(2).errors_on(:password)
    end

    it "is invalid without a password_confirmation" do
      expect(FactoryGirl.build(:user, password_confirmation: nil)).to have(1).errors_on(:password_confirmation)
    end

    it "is invalid if password_confirmation doesn't match password" do
      expect(FactoryGirl.build(:user, password_confirmation: "wrong")).to have(1).errors_on(:password_confirmation)
    end

    it "is invalid with a short password under 6 chars" do
      expect(FactoryGirl.build(:user, password: "lesss", password_confirmation: "lesss")).to have(1).errors_on(:password)
    end

    it "is invalid with a long password over 50 chars" do
      tolong = 's' * 51
      expect(FactoryGirl.build(:user, password: tolong, password_confirmation: tolong)).to have(1).errors_on(:password)
    end

    it "has a token initially expired" do
      subject.save
      expect(subject.token.expires_at).to be < Time.zone.now
    end
  end
end
