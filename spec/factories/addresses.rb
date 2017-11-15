FactoryBot.define do
  factory :address do
    user nil
    latitude 1.5
    longitude 1.5
    country "MyString"
    city "MyString"
    street "MyString"
    building_type 1
    building_name "MyString"
    unit_number "MyString"
    villa_number "MyString"
  end
end
