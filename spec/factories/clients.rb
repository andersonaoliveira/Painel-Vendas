FactoryBot.define do
  factory :client do
    eni { '49773455092' }
    eni_status { 'active' }
    name { 'Carl Sagan' }
    email { 'carl@sagan.com' }
  end
end
