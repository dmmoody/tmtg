FactoryBot.define do
  factory :employee do
    employee_id { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    address { Faker::Address.full_address }
    country { Faker::Address.country }
    bio { Faker::Lorem.paragraphs(number: 1) }
    rating { Faker::Number.decimal(l_digits: 2) }
  end
end