FactoryBot.define do
  factory :vet do
    name "MyString"
    email "MyString"
    mobile_number "MyString"
    avatar "MyString"
    is_active false
    is_emergency false
    consultation_fee 1.5
    clinis nil
  end
end
