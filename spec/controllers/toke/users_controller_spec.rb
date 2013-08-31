require 'spec_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      describe "given valid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}
        let(:user) { double('user') }

        it "it responds with 201" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.status).to equal 201
        end

        it "creates a user" do
          User.stub(:new).with(user_attrs.stringify_keys).and_return(user)
          user.should_receive(:save).and_return(true)
          post :create, user: user_attrs, use_route: 'toke'
        end

        it "renders the user as JSON" do
          User.stub(:new).with(user_attrs.stringify_keys).and_return(user)
          user.stub(:save).and_return(true)
          controller.should_receive(:render).with(json: user, status: 201)
          controller.should_receive(:render)
          post :create, user: user_attrs, use_route: 'toke'
        end
      end

      describe "given invalid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'matsui' }}

        it "it responds with 500" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.status).to equal 500
        end

        it "responds with a blank body" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.body).to be_blank
        end
      end
    end
  end
end
