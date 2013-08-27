require 'test_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __FILE__)).first

describe 'Create Session' do
  include Rack::Test::Methods

  let(:app) { OUTER_APP }
  let(:sesh_attrs) {{ username: 'jack', password: 'secret' }}

  describe 'with valid session attributes' do

    it 'returns an auth token with 201 status' do
      post "/toke/session", session: sesh_attrs
      last_response.status.must_equal 201
      last_resposne.body.must_include "\"toke\":"
    end
  end
end
