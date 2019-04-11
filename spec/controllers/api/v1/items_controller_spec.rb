require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  describe '#quick_search_items' do
    let(:succsess_response_message) do
      { 'items' => [{ 'id' => @item.id,
                     'name' => @item.name,
                     'picture' => { 'medium' => { 'url' => nil }, 'thumb' => { 'url' => nil }, 'url' => nil } }],
        'brands' => [{ 'id' => @brand.id,
                     'name' => @brand.name,
                     'picture' => { 'medium' => { 'url' => nil }, 'thumb' => { 'url' => nil }, 'url' => nil } }] }
    end
    let(:params) { { keyword: 'food' } }
    subject { get :quick_search_items, params: params }
    before do
      @request, @user, @session = auth_user(@request)
      item_cat = create(:item_categories)
      @item = create(:item, item_categories_id: item_cat.id, name: 'food')
      @brand = create(:item_brand, name: 'food')
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
end
