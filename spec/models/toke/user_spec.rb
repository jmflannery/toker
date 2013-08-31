require 'spec_helper'

module Toke

  describe User do

    let(:valid_params) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

    subject { User.new(valid_params) }

    it "is valid with valid params" do
      expect(subject).to be_valid
    end
  end
end
