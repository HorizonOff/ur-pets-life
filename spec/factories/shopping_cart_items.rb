FactoryBot.define do
  factory :shopping_cart_item do
    IsRecurring { false }
    Interval { 1 }
    quantity { 1 }
    item { nil }
    user { nil }
  end
end
