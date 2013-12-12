require 'spec_helper'

module Toke

  describe UsersController do

    describe "POST create" do

      let(:valid_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'suzuki' }}
      let(:user) { FactoryGirl.create(:user) }

      describe "with a valid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token, user: user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given valid atributes" do

          let(:xuser) { double('user') }

          it "it responds with 201" do
            post :create, user: valid_attrs, use_route: 'toke'
            expect(response.status).to eq 201
          end

          it "creates a user" do
            User.stub(:new).with(valid_attrs.stringify_keys).and_return(xuser)
            xuser.should_receive(:save).and_return(true)
            post :create, user: valid_attrs, use_route: 'toke'
          end

          it "renders the user as JSON" do
            User.stub(:new).with(valid_attrs.stringify_keys).and_return(xuser)
            xuser.stub(:save).and_return(true)
            controller.should_receive(:render).with(json: xuser, status: 201)
            controller.should_receive(:render)
            post :create, user: valid_attrs, use_route: 'toke'
          end
        end

        describe "given invalid atributes" do

          let(:user_attrs) {{ username: 'ichiro', password: 'suzuki', password_confirmation: 'matsui' }}

          it "responds with 500" do
            post :create, user: user_attrs, use_route: 'toke'
            expect(response.status).to eq 500
          end

          it "responds with a blank body" do
            post :create, user: user_attrs, use_route: 'toke'
            expect(response.body).to be_blank
          end
        end
      end

      context "with no Toke key in the header" do

        it "returns 401 Unauthorized" do
          post :create, user: valid_attrs, use_route: 'toke'
          expect(response.status).to equal 401
        end
      end
 
      context "with an expired Toke key in the header" do

        let(:token) { FactoryGirl.create(:token, user: user) }
        before do
          token.update(expires_at: 1.second.ago)
          request.headers['X-Toke-Key'] = token.key
        end

        it "returns 401 Unauthorized" do
          post :create, user: valid_attrs, use_route: 'toke'
          expect(response.status).to equal 401
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
