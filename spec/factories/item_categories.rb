FactoryBot.define do
  factory :item_categories, class: ItemCategory do
    name { 'MyString' }
    picture { nil }
    IsHaveBrand { true }
  end
end
