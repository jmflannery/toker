require 'test_helper'

module Toke

  describe User do

    let(:valid_params) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

    subject { User.new(valid_params) }

    it "is valid with valid params" do
      subject.must_be :valid?
    end

    it "converts to JSON" do
      subject.save
      expected = { id: subject.id, username: subject.username }
      subject.as_json.must_equal expected
    end
  end
end
