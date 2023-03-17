FactoryBot.define do
  factory :student do
    nome { Faker::Name.name }
    cpf {  CPF.generate  }
    data_nascimento { '1981-11-12' }
    telefone { 11_111_111 }
    genero { 'm' }
    meio_pagamento { 'cartao' }
    user { create(:user) }

    after(:create) do |student|
      student.student_association { create(:association, user: student.user, associationble: student) }
    end
  end
end
