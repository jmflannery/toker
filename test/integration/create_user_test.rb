require 'test_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __FILE__)).first

describe 'Create User' do
  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  it 'must create a user' do
    post "/toke/users", name: "jack", password: "secret", password_confirmation: "secret"
    assert last_response.ok?
  end
end
