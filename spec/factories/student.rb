FactoryBot.define do
  factory :student do
    nome { 'testeStudent' }
    cpf { '20548269017' }
    data_nascimento { '1981-11-12' }
    telefone { 11_111_111 }
    genero { 'm' }
    meio_pagamento { 'cartao' }
    user { create(:user) }
  end
end
