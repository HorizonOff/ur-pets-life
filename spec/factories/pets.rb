FactoryBot.define do
  factory :pet do
    user
    name { 'MyString' }
    birthday { Time.now }
    sex { 'female' }
    pet_type
    additional_type { 'MyText' }
    breed_id { nil }
    weight { 1.5 }
    comment { 'MyText' }
    description { 'MyString' }
    factory :found_pet, class: Pet do
      found_at { Time.now.to_i }
      mobile_number { '+442' + Faker::Number.number(9).to_s }
      association :location, factory: :location
    end
  end
end
