class Student < ApplicationRecord
  require "cpf_cnpj"
  has_many :registrations, dependent: :delete_all
  has_one :student_association, as: :associationable, class_name: "Association"
  has_one :user, through: :student_association, source_type: 'User'

  validates :nome, presence: true, uniqueness: { message: "Nome Já Utilizado" }
  validates :cpf, presence: true, uniqueness: { message: "Cpf Já Utilizado" }
  validates :genero, presence: true
  validates :meio_pagamento, presence: true
  validate -> { errors.add(:cpf, "Cpf nao valido") unless CPF.valid?(cpf, strict: true) }
  validate -> { errors.add(:genero, "Genero nao valido") unless ['m', 'f'].include?(genero.downcase) }
  validate -> { errors.add(:meio_pagamento, "Metodo de pagamento invalido") unless ["boleto", "cartao"].include?(meio_pagamento.downcase) }
  validate :user_has_institution, on: [:edit, :update]

  def user_has_institution
    errors.add(:user_id, "Usuario já foi atribuido a uma universidade") unless
     self.user.institution == nil
  end

  def change_user(new_user)
    self.student_association.destroy unless self.student_association == nil
    self.user = new_user
    self.save!
  end
end
