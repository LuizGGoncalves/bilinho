FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { '123456789' }
    password_confirmation { '123456789' }
  end
end
