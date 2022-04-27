FactoryBot.define do
  factory :user do
    email { SecureRandom.hex(10) + "@example.com" }
    name { SecureRandom.hex(10) + " Name" }
    password { SecureRandom.hex(10) }
  end
end