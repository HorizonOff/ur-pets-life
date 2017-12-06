FactoryBot.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email }
    mobile_number         '+442211542214'
    confirmed_at           { Time.now.getlocal }
    password              'foxtrapp'
    password_confirmation 'foxtrapp'
  end
end
