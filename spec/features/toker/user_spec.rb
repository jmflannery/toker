require 'rails_helper'

module Toker

  describe "User" do
    include Rack::Test::Methods

    let(:app) { Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __dir__)).first }

    let(:current_user) { FactoryGirl.create(:user) }

    describe 'Register' do

      let(:user_attrs) {{ email: "jack@helo.net", password: "secret", password_confirmation: "secret" }}
      let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

      context 'with a valid token' do

        before do
          token.generate_key!
          token.save
          header 'Authorization', "Bearer #{token.key}"
        end

        context 'with valid user attributes' do

          it 'returns 201 Created with the user in JSON format' do
            post "/toke/register", user: user_attrs
            expect(last_response.status).to eq 201
            user = JSON.parse(last_response.body)['toker/user'].symbolize_keys
            expect(user[:email]).to eq user_attrs[:email]
          end
        end
      end

      context 'with an invalid token' do

        before do
          header 'Authorization', "Bearer 123-bad-token-789"
        end

        context 'with valid user attributes' do

          it 'returns 401 Unauthorized' do
            post "/toke/register", user: user_attrs
            expect(last_response.status).to eq 401
          end
        end
      end
    end

    describe 'Index' do

      let!(:user1) { User.create(email: 'mark@example.net', password: 'secret', password_confirmation: 'secret') }
      let!(:user2) { User.create(email: 'anthony@example.com', password: 'secret', password_confirmation: 'secret') }
      let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

      context 'with a valid token' do

        before do
          token.generate_key!
          token.save
          header 'Authorization', "Bearer #{token.key}"
        end

        it "returns 200 OK with all users in JSON format" do
          get "/toke/users"
          expect(last_response.status).to eq 200
          users = JSON.parse(last_response.body)['toker/users']
          expect(users.size).to be 3
          ids = users.map { |u| u['id'] }
          expect(ids).to include current_user.id
          expect(ids).to include user1.id
          expect(ids).to include user2.id
        end
      end

      context 'with an invalid token' do
        before do
          header 'Authorization', "Bearer 123-bad-token-789"
        end

        it "returns 401 Unauthorized" do
          get "/toke/users"
          expect(last_response.status).to eq 401
        end
      end
    end

    describe 'Show' do

      let!(:user1) { User.create(email: 'mark@example.net', password: 'secret', password_confirmation: 'secret') }
      let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

      context 'with a valid token' do

        before do
          token.generate_key!
          token.save
          header 'Authorization', "Bearer #{token.key}"
        end

        it "returns 200 OK with the user in JSON format" do
          get "/toke/users/#{user1.id}"
          expect(last_response.status).to eq 200
          user = JSON.parse(last_response.body)['toker/user']
          expect(user['email']).to eq user1.email
          expect(user['id']).to eq user1.id
        end
      end

      context 'with an invalid token' do
        before do
          header 'Authorization', "Bearer 123-bad-token-789"
        end

        it "returns 401 Unauthorized" do
          get "/toke/users/#{user1.id}"
          expect(last_response.status).to eq 401
        end
      end
    end
  end
end
