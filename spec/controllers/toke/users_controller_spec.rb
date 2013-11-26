require 'spec_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      describe "given valid atributes" do

        let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}
        let(:user) { double('user') }

        it "it responds with 201" do
          post :create, user: user_attrs, use_route: 'toke'
          expect(response.status).to eq 201
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

    describe "GET index" do

      it "returns 200 status" do
        json = double('json')
        User.should_receive(:all).and_return(json)
        get :index, use_route: 'toke'
        expect(response.status).to eq 200
      end

      it "gets renders all the users as JSON" do
        json = double('json')
        User.should_receive(:all).and_return(json)
        controller.should_receive(:render).with(json: json)
        controller.should_receive(:render)
        get :index, use_route: 'toke'
      end
    end

    describe "GET show" do

      it "finds and renders the given user" do
        user = double('user')
        User.should_receive(:find).with('22').and_return(user)
        controller.should_receive(:render).with(json: user)
        controller.should_receive(:render)
        get :show, id: 22, use_route: 'toke'
      end
    end
  end
end
