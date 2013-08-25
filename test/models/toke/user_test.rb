require 'test_helper'

module Toke

  describe User do

    let(:valid_params) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

    it "is valid with valid params" do
      user = User.new(valid_params)
      user.must_be :valid?
    end
  end
end
