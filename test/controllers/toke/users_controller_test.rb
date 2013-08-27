require 'test_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      describe "given valid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}
        let(:user) { mock('user') }

        before {
          User.stubs(:new).with(user_attrs.stringify_keys).returns(user)
          user.stubs(:save).returns(true)
          user.stubs(:as_json)
        }

        it "it responds with 201" do
          post :create, user: user_attrs, use_route: 'toke'
          response.status.must_equal 201
        end

        it "creates a user" do
          user.expects(:save).returns(true)
          post :create, user: user_attrs, use_route: 'toke'
        end

        it "renders the user as json" do
          json = mock('json')
          user.expects(:as_json).returns(json)
          @controller.expects(:render)
          @controller.expects(:render).with(json: json, status: 201)
          post :create, user: user_attrs, use_route: 'toke'
        end
      end

      describe "given invalid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'matsui' }}
        let(:user) { mock('user') }

        before {
          User.stubs(:new).with(user_attrs.stringify_keys).returns(user)
          user.stubs(:save).returns(false)
        }

        it "it responds with 500" do
          post :create, user: user_attrs, use_route: 'toke'
          response.status.must_equal 500
        end
      end
    end
  end
end
