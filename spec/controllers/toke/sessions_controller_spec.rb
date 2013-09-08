require 'spec_helper'

module Toke

  describe SessionsController do

    describe 'POST create' do

      let(:user) { FactoryGirl.create(:user) }

      context 'given valid credentials' do

        let(:sesh) {{ username: user.username, password: 'secret' }}

        it "returns the users token" do
          post :create, session: sesh, use_route: 'toke'
          user.reload
          expect(response.body).to match \
            /^{"token":{"id":#{user.token.id},"key":"#{user.token.key}","expires_at":"#{user.token.expires_at.to_s(:db)}"}}$/
        end
      end
    end
  end
end
