require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

module Toke

  describe "User" do
    include Rack::Test::Methods

    let(:app) { OUTER_APP }

    describe 'Create' do

      let(:current_user) { FactoryGirl.create(:user) }
      let(:token) { FactoryGirl.create(:token, user: current_user) }
      let(:user_attrs) {{ username: "jack", password: "secret", password_confirmation: "secret" }}

      context 'with a valid Toke key in the header' do

        describe 'with valid user attributes' do

          it 'returns the user as JSON with 201 status' do
            header "X-Toke-Key", token.key
            post "/toke/users", user: user_attrs
            expect(last_response.status).to eq 201
            expect(last_response.body).to match /^{"user":{"id":\d+,"username":"jack","token":null}}$/
          end
        end
      end

      context 'without a valid Toke key in the header' do

        describe 'with valid user attributes' do

          it 'returns 401 Unauthorized' do
            post "/toke/users", user: user_attrs
            expect(last_response.status).to eq 401
          end
        end
      end
    end

    describe 'Index' do
      
      let!(:user1) { User.create(username: 'mark', password: 'secret', password_confirmation: 'secret') }
      let!(:user2) { User.create(username: 'anthony', password: 'secret', password_confirmation: 'secret') }
      let!(:token) { FactoryGirl.create(:token, user: user1) }

      it "gets all users as JSON with 200 status" do
        get "/toke/users"
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq %Q{{"users":[{"id":#{user1.id},"username":"mark","token":{"id":#{token.id},"key":"#{token.key}","expires_at":"#{token.expires_at.to_s(:db)}","user_id":#{user1.id}}},{"id":#{user2.id},"username":"anthony","token":null}]}}
      end
    end

    describe 'Show' do

      let!(:user1) { User.create(username: 'mark', password: 'secret', password_confirmation: 'secret') }
      let!(:token) { FactoryGirl.create(:token, user: user1) }

      it "gets the user as JSON with 200 status" do
        get "/toke/users/#{user1.id}"
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq %Q{{"user":{"id":#{user1.id},"username":"mark","token":{"id":#{token.id},"key":"#{token.key}","expires_at":"#{token.expires_at.to_s(:db)}","user_id":#{user1.id}}}}}
      end
    end
  end
end
