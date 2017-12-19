FactoryBot.define do
  factory :diagnosis do
    appointment nil
    message "MyText"
    next_appointment_id 1
  end
end
