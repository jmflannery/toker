require 'rails_helper'

module Toker

  describe "Toke Authentication" do
    include Rack::Test::Methods

    let(:app) { Rack::Builder.parse_file(File.expand_path('../../dummy/config.ru', __dir__)).first }

    let(:current_user) { FactoryGirl.create(:user) }
    let(:token) { FactoryGirl.create(:token, user: current_user, expires_at: 1.year.from_now) }

    let!(:thing1) { Thing.create published: true }
    let!(:thing2) { Thing.create }

    describe 'using before_action toke!' do

      context 'with the default unauthorized_handler' do

        context 'with a valid token' do

          before do
            token.generate_key!
            token.save
            header 'Authorization', "Bearer #{token.key}"
          end

          it 'gets all things' do
            get 'admin/things'
            expect(last_response.status).to eq 200
            things = JSON.parse(last_response.body)
            expect(things.size).to eq 2
            ids = things.map { |t| t['id'] }
            expect(ids).to include thing1.id, thing2.id
          end
        end

        context 'with an invalid token' do

          before do
            header 'Authorization', "Bearer wrong"
          end

          it 'returns 401 unauthorized' do
            get 'admin/things'
            expect(last_response.status).to eq 401
          end

          it 'return an error message' do
            get 'admin/things'
            errors = JSON.parse(last_response.body)
            expect(errors['Unauthorized']).to eq 'Token invalid'
          end
        end

        context 'with no token' do
          it 'returns 401 unauthorized' do
            get 'admin/things'
            expect(last_response.status).to eq 401
          end

          it 'returns an error message' do
            get 'admin/things'
            errors = JSON.parse(last_response.body)
            expect(errors['Unauthorized']).to eq 'Token required'
          end
        end
      end

      context 'given an unauthorized_handler' do

        context 'given a valid token' do

          before do
            token.generate_key!
            token.save
            header 'Authorization', "Bearer #{token.key}"
          end

          it 'gets all things' do
            get 'things'
            expect(last_response.status).to eq 200
            things = JSON.parse(last_response.body)
            expect(things.size).to eq 2
            ids = things.map { |t| t['id'] }
            expect(ids).to include thing1.id, thing2.id
          end
        end

        context 'given no token' do

          it 'executes the given unauthorized_handler (returns only published things)' do
            get 'things'
            expect(last_response.status).to eq 420
            things = JSON.parse(last_response.body)
            expect(things.size).to eq 1
            expect(things[0]['id']).to eq thing1.id
          end
        end
      end
    end
  end
end
