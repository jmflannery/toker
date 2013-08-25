require 'spec_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      describe "given valid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}

        it "it responds with 201" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.status).to equal 201
        end

        it "creates a user" do
          user = double('user')
          User.stub(:new).with(user_attrs.stringify_keys).and_return(user)
          user.should_receive(:save).and_return(true)
          post :create, user: user_attrs, use_route: 'toke'
        end
      end

      describe "given invalid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'matsui' }}

        it "it responds with 500" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.status).to equal 500
        end
      end
    end
  end
end
