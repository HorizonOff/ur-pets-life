FactoryBot.define do
  factory :post do
    user nil
    title "MyString"
    message "MyText"
    comments_count 1
    pet_type nil
  end
end
