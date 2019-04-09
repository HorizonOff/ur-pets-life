FactoryBot.define do
  factory :session do
    token { 'MyString' }
    device_type { 'ios' }
    device_id { 'MyString' }
    push_token { 'MyString' }
    user
  end
end
