FactoryBot.define do
  factory :order do
    references { "" }
    references { "" }
    Delivery_Date { "2018-10-23 06:02:31" }
    Order_Notes { "" }
    Delivery_Charges { 1 }
    Vat_Charges { 1 }
    Total { 1 }
    IsCash { false }
    Order_Status { 1 }
    Payment_Status { 1 }
  end
end
