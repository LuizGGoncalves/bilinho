FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { '123456789' }
    password_confirmation { '123456789' }
  end

  trait :institution_user do
    user_type { 'Institution' }
    roles { ["INSTITUTION"] }
  end

  trait :admin do
    roles { ["ADMIN"] }
  end
end
