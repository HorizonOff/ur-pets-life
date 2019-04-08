FactoryBot.define do
  factory :appointment do
    association :bookable, factory: :clinic
    association :vet, factory: :vet_with_shedule
    user
    comment 'MyString'
    start_at { Time.now + 1.day }
    # end_at { Time.now + 1.hour }
    number_of_days 2
    status 1
    total_price 100
  end
end
