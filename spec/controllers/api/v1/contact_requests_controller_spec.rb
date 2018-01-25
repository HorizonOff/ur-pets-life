require 'rails_helper'

RSpec.describe Api::V1::ContactRequestsController, type: :controller do
  describe '#create' do
    let(:contact_request_params) do
      attributes_for(:contact_request)
    end
    subject { post :create, params: { contact_request: contact_request_params} }

    context 'When user not Authenticated ' do
      let(:success_response_message) do
        { 'errors' => { 'error' => 'Not Authorized' } }
      end

      it 'returns unsuccess response' do
        subject

        expect(response).not_to be_success
      end

      it 'returns proper status 401' do
        subject

        expect(response.status).to eq(401)
      end

      it 'returns message unsuccess response' do
        subject

        expect(JSON.parse(response.body)).to eq(success_response_message)
      end
    end

    context 'When user Authenticated' do
      before do
        @request, @user, @session = auth_user(@request)
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
      let(:message_success) do
        { 'message' => 'Successfully created' }
      end

      context 'Blank all params' do
        before do
          post :create, params: { contact_request: { subject: '', message: '' } }
        end
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
        before do
          post :create, params: { contact_request: { subject: '', message: 'Message' } }
        end
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
        before do
          post :create, params: { contact_request: { subject: 'Test subject', message: '' } }
        end
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
        before do
          subject
        end

        it 'returns success response' do
          expect(response).to be_success
        end

        it 'returns proper status 200' do
          expect(response.status).to eq(200)
        end
        it 'returns success message' do
          expect(JSON.parse(response.body)).to eq(message_success)
        end
      end
    end
  end
end
