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

        expect(response.status).to eq(200)
      end

      it 'returns proper format' do
        subject

        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq({ 'user' => parsed_response['user'],
                                        'session_token' => parsed_response['session_token'],
                                        'first_login' => parsed_response['first_login'] })
      end
    end

    context 'when user was not created' do
      let(:error_response_message) do
        { 'errors' => { 'email' => 'Email address is invalid' } }
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

  describe '#update' do
    subject { put :update, params: auth_params }

    let(:last_name) { 'lastname' }

    let(:auth_params) do
      { 'user': {
          'last_name': last_name
      } }
    end

    context 'when user is authenticated' do
      before {  @request, @user, @session = auth_user(@request) }

      context 'and user was updated successfully' do
        let(:success_response) do
          { 'message' => 'User updated successfully' }
        end

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

          expect(JSON.parse(response.body)).to eq(success_response)
        end
      end

      context 'and user was not updated' do
        let(:error_response) do
          { 'errors' => { 'last_name' => 'Last name is invalid' } }
        end
        let(:last_name) { '1' }

        it 'returns error response' do
          subject

          expect(response).to_not be_success
        end

        it 'returns proper error status 422' do
          subject

          expect(response.status).to eq(422)
        end

        it 'returns proper format' do
          subject

          expect(JSON.parse(response.body)).to eq(error_response)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:error_response) {
        { 'errors' => { 'error' => 'Not Authorized' } }
      }

      it 'returns error response' do
        subject

        expect(response).not_to be_success
      end

      it 'returns proper error status 401' do
        subject

        expect(response.status).to eq(401)
      end

      it 'returns error response with proper format' do
        subject

        expect(JSON.parse(response.body)).to eq(error_response)
      end
    end
  end

  describe '#profile' do
    subject { get :profile }

    before {  @request, @user, @session = auth_user(@request) }

    let(:success_response) {
      { 'user' => { 'first_name' => @user.first_name,
                    'last_name' => @user.last_name, 'email' => @user.email,
                    'mobile_number' => @user.mobile_number,
                    'birthday' => @user.birthday, 'gender' => User.genders[@user.gender],
                    'location_attributes' => nil}
      }
    }

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

      expect(JSON.parse(response.body)).to eq(success_response)
    end
  end
end
