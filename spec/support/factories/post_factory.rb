FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText long verion" }
    user
  end
end