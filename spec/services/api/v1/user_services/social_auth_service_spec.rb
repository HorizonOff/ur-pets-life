require 'rails_helper'

describe Api::V1::UserServices::SocialAuthService do
  let(:access_token) { 'token_hash' }
  let(:user) { create(:user) }
  let(:email) { user.email }
  let(:access_token) { 'some_token_hash' }

  subject(:described_object) { described_class.new(access_token) }

  describe '#facebook_auth' do
    subject { described_object.facebook_auth }

    let(:name) { "#{user.first_name} #{user.last_name}" }
    let(:facebook_id) { 'fb_id' }
    let(:fb_user) { instance_double(FbGraph2::User, email: email,
                                    access_token: access_token,
                                    name: name, id: facebook_id ) }
    before do
      user.update(facebook_id: facebook_id)
      allow(FbGraph2::User).to receive_message_chain(
            :me, :fetch).with(fields: %i[name email]).and_return(fb_user)
    end

    context 'when user found by facebook id' do
      it 'returns user object' do
        expect(subject).to eq(user)
      end
    end

    context 'when user not found by facebook id' do
      before do
        user.update(facebook_id: 'fake_id')
        allow(user).to receive(:update_attributes).with(facebook_id: fb_user.id).and_return(true)
      end

      context 'and user found by email' do
        it 'returns user object' do
          expect(subject).to eq(user)
        end
      end

      context 'and user not fount by email' do
        before do
          user.update(facebook_id: 'fake_id')
          user.update(email: 'fake@email.com')
        end

        it 'returns facebook user attributes' do
          expect(subject).to eq(fb_user)
        end
      end
    end
  end

  describe '#google_auth' do
    subject { described_object.google_auth }
    let(:google_id) { 'gl_id' }
    let(:first_name) { user.first_name }
    let(:last_name) { user.last_name }
    let(:google_url) { "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{access_token}" }
    let(:google_success_response) do
      {
        'email' => email,
        'sub' =>  google_id,
        'given_name' => first_name,
        'family_name' => last_name
      }
    end

    let(:google_error_response) do
      {
        'error_description' => 'Invalid Value'
      }
    end

    before do
      user.update(google_id: google_id)
      allow(RestClient).to receive(:get).with(google_url).and_return(double(body: google_success_response.to_json))
    end

    context 'when user found by google id' do
      it 'returns user object' do
        expect(subject).to eq(user)
      end
    end

    context 'when user not found by google id' do
      before do
        user.update(google_id: 'fake_id')
        allow(user).to receive(:update_attributes).with(google_id: google_success_response['sub']).and_return(true)
      end

      context 'and user found by email' do
        it 'returns user object' do
          expect(subject).to eq(user)
        end
      end

      context 'and user not fount by email' do
        before do
          user.update(google_id: 'fake_id')
          user.update(email: 'fake@email.com')
        end

        it 'returns google user attributes' do
          expect(subject).to eq(google_success_response)
        end
      end
    end

    context 'when error_description received' do
      before do
        allow(RestClient).to receive(:get).with(google_url).and_return(double(body: google_error_response.to_json))
      end

      it 'returns nothing' do
        expect(subject).to eq({ :message =>'Access token is invalid' })
      end
    end
  end
end
