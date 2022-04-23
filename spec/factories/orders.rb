FactoryBot.define do
  factory :order do
    status { 'pending' }
    plan_id { 1 }
    cancelation_reason { '' }
    period { 'Mensal' }
    value { 30 }
    client { nil }
    user { nil }
    client_eni { '49773455092' }
  end
end
