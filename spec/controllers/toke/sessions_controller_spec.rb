require 'spec_helper'

module Toke

  describe SessionsController do

    describe 'POST create' do

      let(:user) { FactoryGirl.create(:user) }

      context 'given valid credentials' do

        let(:sesh) {{ username: user.username, password: 'secret' }}

        it "returns 201 Created" do
          post :create, session: sesh, use_route: 'toke'
          expect(response.status).to eq 201
        end

        it "returns the authenticated user with embedded token in JSON format" do
          post :create, session: sesh, use_route: 'toke'
          expect(response.body).to eq UserSerializer.new(user.reload).to_json
        end
      end

      context 'given invalid credentials' do

        let(:sesh) {{ username: user.username, password: 'wrongpw' }}

        it "returns 401 Unauthorized" do
          post :create, session: sesh, use_route: 'toke'
          expect(response.status).to eq 401
          expect(response.body).to be_blank
        end
      end
    end

    describe 'DELETE destroy' do
    
      let(:current_user) { FactoryGirl.create(:user) }
      let!(:token) { FactoryGirl.create(:token, user: current_user) }

      context "given a valid Token id" do

        it "returns 204 No Content" do
          delete :destroy, id: token, use_route: 'toke'
          expect(response.status).to eq 204
        end

        it "destroys the current_user's token" do
          delete :destroy, id: token, use_route: 'toke'
          expect(Token.exists?(token.id)).to be_false
        end
      end

      context "given an invalid Token id" do

        it "returns 404 Not Found" do
          delete :destroy, id: 0, use_route: 'toke'
          expect(response.status).to eq 404
        end
      end
    end
  end
end
