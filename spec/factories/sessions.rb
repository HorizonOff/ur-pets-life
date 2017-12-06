FactoryBot.define do
  factory :session do
    token 'MyString'
    device_type 'MyString'
    device_id 'MyString'
    push_token 'MyString'
    user nil
  end
end
