require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:access_token) { 'token_hash' }
  let(:social_auth_service) { instance_double(Api::V1::UserServices::SocialAuthService, facebook_auth: double,
                                  google_auth: double, error: []) }

  before do
    allow(Api::V1::UserServices::SocialAuthService).to receive(:new)
      .with(access_token).and_return(social_auth_service)
  end

  describe '#create' do
    subject { post :create, params: session_params }

    let(:password) { 'foxtrapp' }
    let(:email) { user.email }
    let(:session_params) do
      {
        email: email,
        password: password,
        device_id: 'device_id',
        device_type: 'device_type'
      }
    end

    context 'when appropriate user was found' do
      context 'and password is valid' do
        it 'returns success response' do
          subject

          expect(response).to be_success
        end

        it 'returns proper success status 200' do
          subject

          expect(response.status).to eq(200)
        end

        it 'returns proper format' do
          subject

          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq('first_login' => parsed_response['first_login'],
                                        'session_token' => parsed_response['session_token'],
                                        'user' => parsed_response['user'])
        end
      end
    end

    context 'when appropriate user was not found' do
      let(:email) { 'fake@email.com' }
      let(:error_response) do
        { 'errors' => { 'message' => 'Incorrect email or Password. Please try again.' } }
      end

      it 'returns error response' do
        subject

        expect(response).to_not be_success
      end

      it 'returns proper success status 422' do
        subject

        expect(response.status).to eq(422)
      end

      it 'returns proper format' do
        subject

        expect(JSON.parse(response.body)).to eq(error_response)
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy }

    before { @request, @user, @session = auth_user(@request) }

    let(:success_response) do
      { 'nothing' => true }
    end

    it 'destroys session' do
      subject

      expect(JSON.parse(response.body)).to eq(success_response)
    end
  end

  describe '#facebook' do
    subject { post :facebook, params: { access_token: access_token } }


    context 'when Api::V1::UserServices::SocialAuthService returns User object' do
      before do
        allow(social_auth_service).to receive(:facebook_auth).and_return(user)
      end

      it 'sign ins user' do
        subject

        allow(controller).to receive(:sign_in_user).once
      end
    end

    context 'when Api::V1::UserServices::SocialAuthService does not return a User object' do
      let(:fb_user) { instance_double(FbGraph2::User, email: user.email,
                                      access_token: access_token,
                                      name: "#{user.first_name} #{user.last_name}", id: 'facebook_id') }

      let(:prefield_response) do
        { 'errors' => {},
          'user' => { 'email' => fb_user.email, 'first_name' => fb_user.name.split.first,
                      'last_name' => fb_user.name.split.last, 'facebook_id' => fb_user.id } }
      end

      before do
        allow(social_auth_service).to receive(:facebook_auth).and_return(fb_user)
      end

      it 'returns proper response' do
        subject

        expect(JSON.parse(response.body)).to eq(prefield_response)
      end
    end
  end

  describe '#google' do
    subject { post :google, params: { access_token: access_token } }


    context 'when Api::V1::UserServices::SocialAuthService returns User object' do

      before do
        allow(social_auth_service).to receive(:google_auth).and_return(user)
      end

      it 'sign ins user' do
        subject

        allow(controller).to receive(:sign_in_user).once
      end

    end

    context 'when Api::V1::UserServices::SocialAuthService does not return a User object' do
      let(:google_success_response) do
        {
          'email' => user.email,
          'sub' =>  'google_id',
          'given_name' => user.first_name,
          'family_name' => user.last_name
        }
      end

      let(:prefield_response) do
        { 'errors' => {},
          'user' => { 'email' => google_success_response['email'], 'first_name' => google_success_response['given_name'],
                      'last_name' => google_success_response['family_name'], 'google_id' => google_success_response['sub'] } }
      end

      before do
        allow(social_auth_service).to receive(:google_auth).and_return(google_success_response)
      end

      it 'returns proper response' do
        subject

        expect(JSON.parse(response.body)).to eq(prefield_response)
      end
    end
  end
end
