require 'rails_helper'

RSpec.describe Api::V1::PetsController, type: :controller do
  let(:not_found_error_message) { { 'errors' => { 'error' => 'Not Found' } } }
  let(:sex_required_error_message) { { 'errors' => { 'sex' => 'Sex is required' } } }
  let(:breed_required_error_message) { { 'errors' => { 'breed_id' => 'Breed is invalid' } } }
  describe '#index' do
    let(:succsess_response_message) do
      { 'pets' => [{ 'id' => @pet.id,
                     'name' => @pet.name,
                     'birthday' => @pet.birthday.to_i,
                     'avatar_url' => nil,
                     'pet_type_id' => @pet.pet_type_id,
                     'mobile_number' => @pet.user.mobile_number }] }
    end
    subject { get :index }
    before do
      @request, @user, @session = auth_user(@request)
      @pet = create(:pet, user: @user)
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
    let(:succsess_response_message) do
      { 'pet' => { 'id' => @pet.id,
                   'name' => @pet.name,
                   'birthday' => @pet.birthday.to_i,
                   'avatar_url' => nil,
                   'pet_type_id' => @pet.pet_type_id,
                   'sex' => 1,
                   'weight' => @pet.weight,
                   'comment' => @pet.comment,
                   'lost_at' => @pet.lost_at,
                   'is_for_adoption' => @pet.is_for_adoption,
                   'municipality_tag' => @pet.municipality_tag,
                   'microchip' => @pet.microchip,
                   'additional_type' => @pet.additional_type,
                   'vaccine_types' => [],
                   'pictures' => [] } }
    end
    let(:params) { { id: @pet.id } }
    subject { get :show, params: params }
    before do
      @request, @user, @session = auth_user(@request)
      @pet = create(:pet, user: @user)
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

    context 'with wrong params' do
      let(:params) { { id: 100 } }
      it 'returns proper status 404' do
        subject
        expect(response.status).to eq(404)
      end
      it 'returns proper format' do
        subject
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(not_found_error_message)
      end
    end
  end

  describe '#create' do
    let(:succsess_response_message) do
      { 'pet' => { 'id' => Pet.last.id,
                   'name' => Pet.last.name,
                   'birthday' => Pet.last.birthday.to_i,
                   'avatar_url' => nil,
                   'pet_type_id' => Pet.last.pet_type_id,
                   'sex' => 1,
                   'weight' => Pet.last.weight,
                   'comment' => Pet.last.comment,
                   'lost_at' => Pet.last.lost_at,
                   'is_for_adoption' => Pet.last.is_for_adoption,
                   'municipality_tag' => Pet.last.municipality_tag,
                   'microchip' => Pet.last.microchip,
                   'additional_type' => Pet.last.additional_type,
                   'vaccine_types' => [],
                   'pictures' => [] } }
    end
    let(:pet_type) { create(:pet_type) }
    let(:params) do
      { pet: { name: 'Tom', birthday: 1_516_217_199, pet_type_id: pet_type.id, weight: 2, sex: 1,
               additional_type: 'type' } }
    end
    subject { post :create, params: params }
    before do
      @request, @user, @session = auth_user(@request)
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

  describe '#update' do
    let(:succsess_response_message) do
      { 'pet' => { 'id' => @pet.id,
                   'name' => @pet.name,
                   'birthday' => @pet.birthday.to_i,
                   'avatar_url' => nil,
                   'pet_type_id' => @pet.pet_type_id,
                   'sex' => 1,
                   'weight' => @pet.weight,
                   'comment' => @pet.comment,
                   'lost_at' => @pet.lost_at,
                   'is_for_adoption' => @pet.is_for_adoption,
                   'municipality_tag' => @pet.municipality_tag,
                   'microchip' => @pet.microchip,
                   'additional_type' => @pet.additional_type,
                   'vaccine_types' => [],
                   'pictures' => [] } }
    end
    let(:params) do
      { id: @pet.id,
        pet: { name: 'Tom', birthday: 1_516_217_199, weight: 2 } }
    end
    subject { put :update, params: params }

    before do
      @request, @user, @session = auth_user(@request)
      @pet = create(:pet, user: @user)
    end
    context 'with valid params' do
      it 'returns proper success status 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'returns proper format' do
        subject
        @pet.reload
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(succsess_response_message)
      end
    end

    context 'with wrong params' do
      context 'when id not found' do
        let(:params) do
          { id: 100,
            pet: { name: 'Tom', birthday: 1_516_217_199, weight: 2 } }
        end
        it 'returns proper status 404' do
          subject
          expect(response.status).to eq(404)
        end
        it 'returns proper format' do
          subject
          @pet.reload
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq(not_found_error_message)
        end
      end
      context 'when sex is invalid' do
        let(:params) do
          { id: @pet.id,
            pet: { name: 'Tom', birthday: 1_516_217_199, weight: 2, sex: 'invalid' } }
        end
        it 'returns proper status 422' do
          subject
          expect(response.status).to eq(422)
        end
        it 'returns proper format' do
          subject
          @pet.reload
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq(sex_required_error_message)
        end
      end
      context 'when breed is invalid' do
        let(:params) do
          { id: @pet.id,
            pet: { name: 'Tom', birthday: 1_516_217_199, weight: 2, breed_id: 100 } }
        end
        it 'returns proper status 422' do
          subject
          expect(response.status).to eq(422)
        end
        it 'returns proper format' do
          subject
          @pet.reload
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq(breed_required_error_message)
        end
      end
    end
  end

  describe '#destroy' do
    let(:succsess_response_message) do
      { 'nothing' => true }
    end
    let(:params) { { id: @pet.id } }
    subject { delete :destroy, params: params }
    before do
      @request, @user, @session = auth_user(@request)
      @pet = create(:pet, user: @user)
    end
    context 'with valid params' do
      it 'returns proper success status 204' do
        subject
        expect(response.status).to eq(204)
      end
      it 'returns proper format' do
        subject
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(succsess_response_message)
      end
    end
    context 'with wrong params' do
      let(:params) { { id: 100 } }
      it 'returns proper status 404' do
        subject
        expect(response.status).to eq(404)
      end
      it 'returns proper format' do
        subject
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(not_found_error_message)
      end
    end
  end

  describe '#lost' do
    let(:params) do
      { id: @pet.id,
        pet: { description: 'Tom', mobile_number: '+34053452392', additional_comment: 'cat',
               lost_at: 1_516_217_199,
               location_attributes: attributes_for(:location) } }
    end
    subject { put :lost, params: params }
    context 'with valid params' do
      before do
        @request, @user, @session = auth_user(@request)
        @pet = create(:pet, user: @user)
      end
      let(:succsess_response_message) do
        { 'message' => 'Pet updated successfully' }
      end
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

    context 'with wrong params' do
      context 'when lost_at and found_at present' do
        let(:lost_found_error_message) do
          { 'errors' => { 'lost_at' => "Pet can't be lost and found at the same time" } }
        end
        before do
          @request, @user, @session = auth_user(@request)
          @pet = create(:found_pet, user: @user)
        end
        it 'returns proper status 422' do
          subject
          expect(response.status).to eq(422)
        end
        it 'returns proper format' do
          subject
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq(lost_found_error_message)
        end
      end
    end
  end

  describe '#change_status' do
    let(:params) do
      { id: @pet.id,
        pet: { is_lost: false, is_for_adoption: true } }
    end
    subject { put :change_status, params: params }
    context 'with valid params' do
      before do
        @request, @user, @session = auth_user(@request)
        @pet = create(:pet, user: @user)
      end
      let(:succsess_response_message) do
        { 'pet' => { 'id' => Pet.last.id,
                     'name' => Pet.last.name,
                     'birthday' => Pet.last.birthday.to_i,
                     'avatar_url' => nil,
                     'pet_type_id' => Pet.last.pet_type_id,
                     'sex' => 1,
                     'weight' => Pet.last.weight,
                     'comment' => Pet.last.comment,
                     'lost_at' => Pet.last.lost_at,
                     'is_for_adoption' => Pet.last.is_for_adoption,
                     'municipality_tag' => Pet.last.municipality_tag,
                     'microchip' => Pet.last.microchip,
                     'additional_type' => Pet.last.additional_type,
                     'vaccine_types' => [],
                     'pictures' => [] } }
      end
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

  describe '#can_be_lost' do
    subject { get :can_be_lost }
    context 'with valid params' do
      before do
        @request, @user, @session = auth_user(@request)
        @pet = create(:pet, user: @user)
      end
      let(:succsess_response_message) do
        { 'pets' => [{ 'id' => @pet.id,
                       'name' => @pet.name,
                       'birthday' => @pet.birthday.to_i,
                       'avatar_url' => nil,
                       'pet_type_id' => @pet.pet_type_id,
                       'mobile_number' => @pet.user.mobile_number }] }
      end
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

  describe '#can_be_adopted' do
    subject { get :can_be_adopted }
    context 'with valid params' do
      before do
        @request, @user, @session = auth_user(@request)
        @pet = create(:pet, user: @user)
      end
      let(:succsess_response_message) do
        { 'pets' => [{ 'id' => @pet.id,
                       'name' => @pet.name,
                       'birthday' => @pet.birthday.to_i,
                       'avatar_url' => nil,
                       'pet_type_id' => @pet.pet_type_id,
                       'mobile_number' => @pet.user.mobile_number }] }
      end
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

  describe '#found_pets' do
    let(:params) { { longitude: 48, latitude: 48 } }
    subject { get :found_pets, params: params }
    context 'with valid params' do
      before do
        @request, @user, @session = auth_user(@request)
        @pet = create(:found_pet, user: @user)
      end
      let(:succsess_response_message) do
        { 'pets' => [{ 'id' => @pet.id,
                       'description' => @pet.description,
                       'address' => @pet.location.city + ', ' + @pet.location.area + ', ' +
                                      @pet.location.street + ', ' + @pet.location.villa_number,
                       'avatar_url' => nil,
                       'distance' => 0.0,
                       'pet_type_id' => @pet.pet_type_id,
                       'lost_at' => @pet.lost_at,
                       'found_at' => @pet.found_at.to_i }] }
      end
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
end
