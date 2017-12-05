require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user) }

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
end
