FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.org" }
    password "secret"

    factory :user_with_wishlists do
      transient { wishlists_count 3 }
      after(:create) do |user, evaluator|
        create_list(:wishlist, evaluator.wishlists_count, user: user)
      end

      factory :bob do
        email "bob@example.org"
      end

      factory :alice do
        email "alice@example.org"
      end
    end
  end
end
