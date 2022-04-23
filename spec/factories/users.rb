FactoryBot.define do
  factory :user do
    name { 'Alan Turing' }
    sequence(:email) { |n| "user#{n}@locaweb.com.br" }
    password { '12345678' }
    role { :admin }
    status { :active }
  end
end
