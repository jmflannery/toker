require 'rails_helper'

describe "Sessions" do

  include Rack::Test::Methods

  let(:app) { Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __dir__)).first }

  let(:current_user) { FactoryGirl.create(:user, email: 'nikki') }

  describe "Log In (with email and password)" do

    context "given valid credentials" do

      before do
        creds = ["#{current_user.email}:secret"].pack("m*")
        header 'Authorization', "Basic #{creds}"
      end

      it 'returns 201 Created' do
        post 'toke/login'
        expect(last_response.status).to eq 201
      end

      it 'returns an Authorization Token in the header' do
        post 'toke/login'
        token_header = last_response.headers['Authorization']
        expect(token_header).to match /\AToken .*\..*\..*\z/
      end

      it 'returns the user record in the body' do
        post 'toke/login'
        response_body = JSON.parse(last_response.body)['toke/user']
        expect(response_body['email']).to eq current_user.email
      end

      it 'returns a unique token with each request' do
        post 'toke/login'
        previous_token = last_response.headers['Authorization'].split.last
        post 'toke/login'
        token = last_response.headers['Authorization'].split.last
        expect(previous_token).not_to eq token
      end

      it 'makes previous tokens invalid' do
        post 'toke/login'
        previous_token = last_response.headers['Authorization'].split.last
        post 'toke/login'
        header 'Authorization', "Token #{previous_token}"
        delete 'toke/logout'
        expect(last_response.status).to eq 401
      end
    end

    context 'with invalid credientials' do

      before do
        creds = ["#{current_user.email}:wrong"].pack("m*")
        header 'Authorization', "Basic #{creds}"
      end

      it 'returns 401 Unathorized' do
        post 'toke/login'
        expect(last_response.status).to eq 401
      end
    end
  end
  describe 'Log In (with Token)' do

    describe 'with a valid Token' do

      let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

      before do
        token.generate_key!
        token.save
        header 'Authorization', "Bearer #{token.key}"
      end

      it 'returns 200 OK' do
        put 'toke/login'
        expect(last_response.status).to eq 200
      end

      it 'returns an Authorization Token in the header' do
        put 'toke/login'
        token_header = last_response.headers['Authorization']
        expect(token_header).to match /\AToken .*\..*\..*\z/
      end

      it 'returns the user record in the body' do
        put 'toke/login'
        response_body = JSON.parse(last_response.body)['toke/user']
        expect(response_body['email']).to eq current_user.email
      end
    end

    describe 'with invalid credientials' do

      before do
        header 'Authorization', "Bearer wrong"
      end

      it 'returns 401 Unathorized' do
        put 'toke/login'
        expect(last_response.status).to eq 401
      end
    end
  end

  describe "Log out" do

    describe 'with a valid token' do

      let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

      before do
        token.generate_key!
        token.save
        header 'Authorization', "Bearer #{token.key}"
      end

      it 'returns 204 No Content' do
        delete 'toke/logout'
        expect(last_response.status).to eq 204
        expect(last_response.body).to be_blank
      end

      it 'causes the token to be invalid on the next request' do
        delete 'toke/logout'
        delete 'toke/logout'
        expect(last_response.status).to eq 401
        msg = JSON.parse(last_response.body)
        expect(msg['Unauthorized']).to eq 'Token invalid'
      end
    end

    describe 'with an invalid token' do

      before do
        header 'Authorization', "Bearer 123-bad-token-789"
      end

      it 'returns 401 Unathorized' do
        delete 'toke/logout'
        expect(last_response.status).to eq 401
      end

      it 'returns an error message' do
        delete 'toke/logout'
        msg = JSON.parse(last_response.body)
        expect(msg['Unauthorized']).to eq 'Token invalid'
      end
    end
  end
end
