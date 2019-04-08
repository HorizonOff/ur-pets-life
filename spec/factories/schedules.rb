FactoryBot.define do
  factory :schedule do
    monday_open_at '2017-12-05 08:24:11'
    monday_close_at '2017-12-05 16:24:11'
    tuesday_open_at '2017-12-05 08:24:11'
    tuesday_close_at '2017-12-05 16:24:11'
    wednesday_open_at '2017-12-05 08:24:11'
    wednesday_close_at '2017-12-05 16:24:11'
    thursday_open_at '2017-12-05 08:24:11'
    thursday_close_at '2017-12-05 16:24:11'
    friday_open_at '2017-12-05 08:24:11'
    friday_close_at '2017-12-05 16:24:11'
    saturday_open_at '2017-12-05 08:24:11'
    saturday_close_at '2017-12-05 16:24:11'
    sunday_open_at '2017-12-05 08:24:11'
    sunday_close_at '2017-12-05 16:24:11'
    association :schedulable, factory: :vet
  end
end
