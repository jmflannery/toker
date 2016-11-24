require 'rails_helper'

module Toke
  RSpec.describe Token, type: :model do

    let(:expires_at) { 1.year.from_now }
    let(:user) { FactoryGirl.create(:user) }

    subject { FactoryGirl.create(:token, user: user, expires_at: expires_at) }

    describe 'payload' do

      it 'includes token_id and exp' do
        expect(subject.payload[:token_id]).to eq subject.id
        expect(subject.payload[:exp]).to eq expires_at.to_i
      end
    end

    describe 'generate_key!' do

      it 'generates a json web token' do
        expect(subject.key).to be_blank
        subject.generate_key!
        expect(subject.key).to match /\A.*\..*\..*\z/
      end
    end

    describe 'decode' do

      context 'given a valid JWT token' do

        before(:each) do
          subject.generate_key!
          subject.save
        end

        it 'can decode a JWT token' do
          token, error = Token.decode(subject.key)
          expect(token.user.id).to eq user.id
          expect(token.expires_at).to eq expires_at
          expect(token.key).to eq subject.key
        end
      end

      context 'given an expired token' do

        before do
          subject.expires_at = 1.minute.ago
          subject.generate_key!
        end

        it 'returns an error message' do
          token, error = Token.decode(subject.key)
          expect(error[:Unauthorized]).to eq 'Token expired'
        end
      end

      context 'given an invalid token' do

        it 'returns an error message' do
          token, error = Token.decode(subject.key)
          expect(error[:Unauthorized]).to eq 'Token invalid'
        end
      end
    end
  end
end
