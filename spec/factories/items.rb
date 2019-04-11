FactoryBot.define do
  factory :item do
    name { 'MyString' }
    buying_price { 10 }
    unit_price { 20 }
    price { 20 }
    discount { 10 }
    weight { 0 }
    description { 'desc' }
    unit { 'unit' }
    item_brand
    picture { nil }
    rating { 0 }
    item_categories_id { 1 }
    pet_type
    avg_rating { 0 }
    quantity { 1 }
    short_description { 'desc' }
  end
end
