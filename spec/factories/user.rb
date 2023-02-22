FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123456789' }
    password_confirmation { '123456789' }
    user_type { 'Student' }
    roles { ['STUDENT'] }
  end

  trait :institution_user do
    user_type { 'Institution' }
    roles { ["INSTITUTION"] }
  end

  trait :admin do
    roles { ["ADMIN"] }
  end
end
