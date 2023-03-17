FactoryBot.define do
  factory :institution do
    nome { 'testeInstitution' }
    cnpj { '16465209000160' }
    tipo { 'Universidade' }
    users { [create(:user)] }

    after(:create) do |institution|
      institution.users.each do |user|
        create(:association, user: user, associationable: institution)
      end
    end
  end
end
