FactoryBot.define do
  factory :bill do
    valor_fatura { 100 }
    data_vencimento { '2000-12-1' }
    registration_id { 1 }
    status { 'Paga' }
  end
end
