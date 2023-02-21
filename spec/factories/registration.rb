FactoryBot.define do
  factory :registration do
    valor_total {1000}
    quantidade_faturas {10}
    vencimento {15}
    nome_curso {"testeCurso"}
    institution_id {1}
    student_id {1}
  end
end
