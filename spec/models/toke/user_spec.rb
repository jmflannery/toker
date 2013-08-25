require 'spec_helper'

module Toke

  describe User do

    let(:valid_params) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

    subject { User.new(valid_params) }

    it "is valid with valid params" do
      expect(subject).to be_valid
    end

    it "converts to JSON like hash" do
      subject.save
      expect(subject.as_json).to eq id: subject.id, username: subject.username
    end
  end
end
