FactoryBot.define do
  factory :user do
    first_name { "Bob" }
    last_name { "Boberson" }
    association :role, factory: :role
    sequence :email do |n|
      "#{first_name}#{n}@example.com"
    end
    password { "password" }
    password_confirmation { "password" }
  end
end
