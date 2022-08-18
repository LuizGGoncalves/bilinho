class Registration < ApplicationRecord
  belongs_to :student
  belongs_to :institution
  has_many :bills, dependent: :delete_all

  validates :valor_total, presence: true
  validates :quantidade_faturas, presence: true
  validates :vencimento, presence: true
  validates :nome_curso, presence: true
  validates :student_id, presence: true
  validates :institution_id, presence: true
  validate -> {errors.add(:valor_total, "O valor do curso deve ser maior que 0"  ) unless valor_total > 0}
  validate -> {errors.add(:quantidade_faturas, "O numero de fatura deve ser maior que 0") unless quantidade_faturas > 0}
  validate -> {errors.add(:vencimento, "Data invalida ") unless vencimento > 0 && vencimento <= 31}
end
