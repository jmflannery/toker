require 'test_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      describe "given valid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

        it "it responds with 201" do
          post :create, user: user_attrs, use_route: 'toke'
          response.status.must_equal 201
        end
      end

      describe "given invalid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'matsui' }}

        it "it responds with 500" do
          post :create, user: user_attrs, use_route: 'toke'
          response.status.must_equal 500
        end
      end
    end
  end
end
