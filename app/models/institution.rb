class Institution < ApplicationRecord
  require "cpf_cnpj"
  has_many :registrations, dependent: :delete_all
  has_many :associations, as: :associationable
  has_many :users, through: :associations, source_type: 'User'

  validates :nome, presence: true, uniqueness: { message: "Nome já utilizado" }
  validates :cnpj, presence: true, uniqueness: { message: "Cnpj já utilizado" }
  validate -> { errors.add(:cnpj, "Cnpj nao valido") unless CNPJ.valid?(cnpj, strict: true) }
  validate -> { errors.add(:tipo, "Categoria nao valida") unless ["Universidade", "Escola", "Creche"].include?(tipo) }


  def add_user(new_user)
    new_user.institution = self
    new_user.save!
  end

  def remove_user(user)
    self.association.find_by(user_id: user.id).destroy!
  end
end
