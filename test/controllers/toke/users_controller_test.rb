require 'test_helper'

module Toke
  describe UsersController do

    describe "POST create" do
      it "the truth" do
        post :create, use_route: 'toke'
        response.body.must_equal "Toke"
      end
    end
  end
end
