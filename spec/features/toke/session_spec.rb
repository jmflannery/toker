require 'rails_helper'

OUTER_APP ||= Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

describe "Sessions" do

  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  describe "Create" do

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

  describe "Destroy" do

    let(:current_user) { FactoryGirl.create(:user) }
    let(:token) { FactoryGirl.create(:token, user: current_user) }

    context 'with a valid Toke key in the header' do

      it "destroys the token and returns 204 No Content" do
        header "X-Toke-Key", token.key
        delete "toke/sessions/#{token.id}"
        expect(Toke::Token.exists?(token.id)).to be false
      end
    end
  end
end
