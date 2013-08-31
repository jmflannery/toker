require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

describe 'Create User' do
  include Rack::Test::Methods

  let(:app) { OUTER_APP }
  let(:user_attrs) {{ username: "jack", password: "secret", password_confirmation: "secret" }}

  describe 'with valid user attributes' do

    it 'returns the user as JSON with 201 status' do
      post "/toke/users", user: user_attrs
      expect(last_response.status).to eq 201
      expect(last_response.body).to match /^{"id":\d+,"username":"jack","password_digest":"\S+","created_at":"\S+","updated_at":"\S+"}$/
    end
  end
end
