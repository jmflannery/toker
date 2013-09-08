require 'spec_helper'

module Toke

  describe Token do
    
    let(:user) { FactoryGirl.create(:user) }
    subject { Token.new(user: user) }

    it "sets the token key" do
      subject.save
      expect(subject.key).to match /\S{32}/
    end

    it "sets the token expiration" do
      now = Time.now
      Time.stub(:now).and_return(now)
      subject.save
      expect(subject.expires_at).to eq (now + 4.hours)
    end
  end
end
