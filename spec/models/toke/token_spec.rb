require 'spec_helper'

module Toke

  describe Token do
    
    let(:user) { FactoryGirl.create(:user) }
    subject { Token.new(user: user) }
    before { subject.save }

    it "initially has a blank key" do
      expect(subject.key).to be_blank
    end

    it "is initially expired" do
      expect(subject.expires_at).to be < Time.now
    end

    it "sets the token key" do
      subject.toke
      expect(subject.reload.key).to match /\S{32}/
    end

    it "sets the token expiration" do
      now = Time.now
      Time.stub(:now).and_return(now)
      subject.toke
      expect(subject.reload.expires_at).to eq (now + 4.hours).to_formatted_s(:rfc822)
    end
  end
end
