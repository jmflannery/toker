require 'spec_helper'

module Toke

  describe SessionsController do

    describe 'POST create' do

      let(:user) { FactoryGirl.create(:user) }

      context 'given valid credentials' do

        let(:sesh) {{ username: user.username, password: 'secret' }}

        it "returns the authenticated user with embedded token in JSON format" do
          post :create, session: sesh, use_route: 'toke'
          expect(response.body).to eq UserSerializer.new(user.reload).to_json
        end
      end
    end
  end
end
