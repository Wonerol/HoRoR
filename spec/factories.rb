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
    attack 1
    defence 1
    min_damage 1
    max_damage 1
    hp 1
    speed 1
    cost 42
  end

  factory :army do
    monster_id { Monster.first.id || FactoryGirl.create(:monster).id }
  end
    
end
