FactoryBot.define do
  factory :item_review do
    user { nil }
    item { nil }
    rating { 1 }
    comment { "MyString" }
  end
end
