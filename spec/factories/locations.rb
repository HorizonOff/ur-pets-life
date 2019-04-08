FactoryBot.define do
  factory :location do
    latitude 48
    longitude 48
    city 'Uzhgorod'
    area 'area'
    street 'Shevchenka'
    building_type 'villa'
    building_name 'Uzhgorod big house'
    unit_number '36'
    villa_number '37'
    comment 'Big place'
    association :place, factory: :pet
  end
end
