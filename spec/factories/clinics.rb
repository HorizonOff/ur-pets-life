FactoryBot.define do
  factory :clinic do
    admin
    name 'MyString'
    email
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/image.jpeg'), 'image/jpeg') }
    mobile_number 'MyString'
    description 'MyText'
    website 'website'
    is_active true
    is_emergency false
    location
  end
end
