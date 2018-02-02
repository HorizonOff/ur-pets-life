require 'rails_helper'

RSpec.describe Api::V1::ContactRequestsController, type: :controller do
  describe '#create' do
    let(:contact_request_params) do
      attributes_for(:contact_request)
    end
    let(:success_response_message) do
      { 'message' => 'Successfully created' }
    end
    subject { post :create, params: { contact_request: contact_request_params} }

    context 'When user not Authenticated' do
      let(:unsuccess_response_message) do
        { 'errors' => { 'email' => 'Email is required' } }
      end

      before do
        subject
      end

      context 'and params[:email] is empty' do
        it 'returns proper status 422' do
          expect(response.status).to eq(422)
        end

        it 'returns message unsuccess response' do
          expect(JSON.parse(response.body)).to eq(unsuccess_response_message)
        end
      end

      context 'and send email in params' do
        subject { post :create, params: { contact_request: contact_request_params.merge(email: 'user2@mail.com')} }

        it 'returns proper status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns success message' do
          expect(JSON.parse(response.body)).to eq(success_response_message)
        end
      end
    end

    context 'When user Authenticated' do
      before do
        @request, @user, @session = auth_user(@request)
        subject
      end

      let(:message_two_field_blank) do
        { 'errors' => { 'subject' => 'Subject is required',
                        'message' => 'Message is required' } }
      end
      let(:message_blank_field_message) do
        { 'errors' => { 'message' => 'Message is required' } }
      end
      let(:message_blank_field_subject) do
        { 'errors' => {  'subject' => 'Subject is required' } }
      end

      context 'Blank all params' do
        subject { post :create, params: { contact_request: { subject: '', message: '' } } }

        it 'returns message/blank two fields' do
          expect(JSON.parse(response.body)).to eq(message_two_field_blank)
        end

        it 'returns proper error status 422' do
          expect(response.status).to eq(422)
        end
        it 'unsuccess response/blank two fields' do
          expect(response).not_to be_success
        end
      end

      context 'Blank params subject' do
        subject { post :create, params: { contact_request: { subject: '', message: 'Message' } } }

        it 'returns error response' do
          expect(response).not_to be_success
        end

        it 'returns proper error status 422' do
          expect(response.status).to eq(422)
        end
        it 'returns error message' do
          expect(JSON.parse(response.body)).to eq(message_blank_field_subject)
        end
      end

      context 'Blank params message' do
        subject { post :create, params: { contact_request: { subject: 'Test subject', message: '' } } }

        it 'returns error response' do
          expect(response).not_to be_success
        end

        it 'returns proper error status 422' do
          expect(response.status).to eq(422)
        end

        it 'returns error message' do
          expect(JSON.parse(response.body)).to eq(message_blank_field_message)
        end
      end

      context 'Valid params' do
        it 'returns success response' do
          expect(response).to be_success
        end

        it 'returns proper status 200' do
          expect(response.status).to eq(200)
        end
        it 'returns success message' do
          expect(JSON.parse(response.body)).to eq(success_response_message)
        end
      end
    end
  end
end
