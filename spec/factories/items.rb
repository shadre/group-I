FactoryGirl.define do
  factory :item do
    name Faker::Lorem.sentence(2)
    description Faker::Lorem.paragraph
    wishlist
  end
end
