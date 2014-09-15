FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :monster do
    sequence(:name) { |n| "Monster #{n}" }
    flavour_text "It's been a tough year for monster mercenaries"
  end
end
