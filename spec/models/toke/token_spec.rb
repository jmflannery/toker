require 'spec_helper'

module Toke

  describe Token do
    
    let(:user) { FactoryGirl.create(:user) }
    subject { Token.new(user: user) }

    let!(:now) { Time.now }
    before do
      Time.stub(:now).and_return(now)
      subject.save
    end

    it "sets the token key" do
      expect(subject.key).to match /\S{32}/
    end

    it "sets the token to expire in 4 hours" do
      expect(subject.reload.expires_at).to eq (now + 4.hours).to_formatted_s(:rfc822)
    end
  end
end
