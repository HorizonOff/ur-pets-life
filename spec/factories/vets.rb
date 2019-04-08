FactoryBot.define do
  sequence(:email) { |n| "test#{n}@gmail.com" }
  factory :vet do
    name 'MyString'
    email
    mobile_number { '+442' + Faker::Number.number(9).to_s }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/image.jpeg'), 'image/jpeg') }
    is_active true
    is_emergency false
    consultation_fee 1.5
    session_duration 2
    clinic
    factory :vet_with_shedule, class: Pet do
      association :schedule, factory: :schedule
    end
  end
end
