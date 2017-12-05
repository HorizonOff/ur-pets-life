require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user_params) do
    { user: attributes_for(:user) }
  end
  let(:device_data) do
    { device_id: 'id', device_type: 'ios' }
  end

  describe '#create' do
    subject { post :create, params: user_params.merge(device_data) }

    context 'when user successfully created' do
      it 'returns success response' do
        subject

        expect(response).to be_success
      end

      it 'returns proper success status 200' do
        subject

        # binding.pry
        expect(response.status).to eq(200)
      end

      it 'returns proper format' do
        subject

        parsed_response = JSON.parse(response.body)


        expect(parsed_response).to eq({"user"=>parsed_response['user'], "session_token"=> parsed_response['session_token'], "first_login"=>parsed_response['first_login']})
      end
    end

    context 'when user was not created' do
      let(:error_response_message) do
        { "errors" => { "email" => "Email address is invalid" } }
      end

      before { user_params[:user].delete(:email) }

      it 'returns error response' do
        subject

        expect(response).not_to be_success
      end

      it 'returns proper error status 422' do
        subject

        expect(response.status).to eq(422)
      end

      it 'returns proper format' do
        subject

        expect(JSON.parse(response.body)).to eq(error_response_message)
      end
    end
  end
end
