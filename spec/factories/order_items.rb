FactoryBot.define do
  factory :order_item do
    order { nil }
    item { nil }
    Quantity { 1 }
    Unit_Price { 1 }
    Total_Price { 1 }
  end
end
