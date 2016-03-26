require 'rails_helper'

module Toke

  describe Token do
    let(:user) { FactoryGirl.create(:user) }
    subject { Token.new(user: user) }

    let!(:now) { Time.now }
    before do
      allow(Time).to receive(:now).and_return(now)
      subject.save
    end

    it "sets the token key" do
      expect(subject.key).to match /\S{32}/
    end

    it "sets the token to expire in 4 hours" do
      expect(subject.reload.expires_at).to eq Time.zone.now + 4.hours
    end

    it "is expired if the current time is greater than the expires_at time" do
      subject.update_attribute(:expires_at, 1.second.ago)
      expect(subject).to be_expired
    end

    it "is not expired until the expires_at time is reached" do
      subject.update_attribute(:expires_at, 1.second.from_now)
      expect(subject).to_not be_expired
    end
  end
end
