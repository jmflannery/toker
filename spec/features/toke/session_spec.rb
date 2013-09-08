require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file(File.expand_path('../../../dummy/config.ru', __FILE__)).first

describe "Sessions" do

  include Rack::Test::Methods

  let(:app) { OUTER_APP }

  describe "create Session" do

    context "given valid parameters" do

      let(:user) { Toke::User.create(username: 'niki', password: 'secret', password_confirmation: 'secret') }
      let(:sesh_attrs) {{ username: 'nikki', password: 'secret' }}

      it "returns an token that expires in 4 hours with 201 status" do
        now = Time.now
        Time.stub(:now).and_return(now)
        post 'toke/sessions', sesh_attrs
        expect(response.status).to be 201
        expect(response.body).to match /^{"token":{"id":#{user.token.id},"key":"#{user.token.key}","expires_at":#{(now + 4.hours)}}}$/
      end
    end
  end
end
