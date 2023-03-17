FactoryBot.define do
  factory :registration do
    valor_total { 1200 }
    quantidade_faturas { 3 }
    vencimento { 15 }
    nome_curso { "testeCurso" }
    institution { create (:institution) }
    student { create (:student) }
  end
end
