FactoryBot.define do
  factory :admin do
    name { 'Admin' }
    email
    password { '11111111' }
    password_confirmation { '11111111' }
  end
end
