require 'rails_helper'

RSpec.describe Api::V1::AppointmentsController, type: :controller do
  describe '#index' do
    let(:succsess_response_message) do
      { 'appointments' => [],
        'total_count' => 0 }
    end
    subject { get :index }
    before do
      @request, @user, @session = auth_user(@request)
      @appointment = create(:appointment, user: @user)
    end
    context 'with valid params' do
      it 'returns proper success status 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'returns proper format' do
        subject
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(succsess_response_message)
      end
    end
  end

  describe '#show' do
    let(:params) { { id: @appointment.id } }
    subject { get :show, params: params }
    before do
      @request, @user, @session = auth_user(@request)
      @appointment = create(:appointment, user: @user)
    end
  end
end
