require 'test_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __FILE__)).first

describe 'Create User' do
  include Rack::Test::Methods

  let(:app) { OUTER_APP }
  let(:user_attrs) {{ username: "jack", password: "secret", password_confirmation: "secret" }}

  describe 'with valid user attributes' do

    it 'is successfull' do
      post "/toke/users", user: user_attrs
      last_response.status.must_equal 201
    end

    it 'returns the user as JSON' do
      post "/toke/users", user: user_attrs
      last_response.body.must_include "\"username\":\"jack\""
    end
  end
end
