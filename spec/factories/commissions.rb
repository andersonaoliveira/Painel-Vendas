FactoryBot.define do
  factory :commission do
    value { '9.99' }
    order_id { 1 }
    user_id { 1 }
  end
end
