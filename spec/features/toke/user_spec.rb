require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

module Toke

  describe "User" do
    include Rack::Test::Methods

    let(:app) { OUTER_APP }

    describe 'Create' do

      let(:user_attrs) {{ username: "jack", password: "secret", password_confirmation: "secret" }}

      describe 'with valid user attributes' do

        it 'returns the user as JSON with 201 status' do
          post "/toke/users", user: user_attrs
          expect(last_response.status).to eq 201
          expect(last_response.body).to match /^{"user":{"id":\d+,"username":"jack"}}$/
        end
      end
    end

    describe 'Index' do
      
      let!(:user1) { User.create(username: 'mark', password: 'secret', password_confirmation: 'secret') }
      let!(:user2) { User.create(username: 'anthony', password: 'secret', password_confirmation: 'secret') }

      it "gets all users as JSON with 200 status" do
        get "/toke/users"
        expect(last_response.status).to eq 200
        expect(last_response.body).to match /^{"users":\[{"id":\d+,"username":"mark"},{"id":\d+,"username":"anthony"}\]}/
      end
    end
  end
end
