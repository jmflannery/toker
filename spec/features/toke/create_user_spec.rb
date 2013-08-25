require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __FILE__)).first

describe 'Create User' do
  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  it 'must create a user' do
    post "/toke/users", { user: { username: "jack", password: "secret", password_confirmation: "secret" }}
    expect(last_response.status).to eq 201
  end
end
