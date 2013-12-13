require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

describe "Sessions" do

  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  describe "create Session" do

    context "given valid parameters" do

      let(:user) { Toke::User.create(username: 'nikki', password: 'secret', password_confirmation: 'secret') }
      let(:sesh_attrs) {{ session: { username: user.username, password: 'secret' }}}

      it "returns a token that expires in 4 hours with 201 status" do
        post 'toke/sessions', sesh_attrs
        user.reload
        expect(last_response.status).to be 201
        expect(last_response.body).to eq %Q{{"user":{"id":#{user.id},"username":"nikki","token":{"id":#{user.token.id},"key":"#{user.token.key}","expires_at":"#{user.token.expires_at.to_s(:db)}","user_id":#{user.id}}}}}
      end
    end
  end
end
