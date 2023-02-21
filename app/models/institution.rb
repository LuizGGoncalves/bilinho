class Institution < ApplicationRecord
  require "cpf_cnpj"
  has_many :registrations, dependent: :delete_all

  validates :nome, presence: true, uniqueness: { message: "Nome já utilizado" }
  validates :cnpj, presence: true, uniqueness: { message: "Cnpj já utilizado" }
  validate -> { errors.add(:cnpj, "Cnpj nao valido") unless CNPJ.valid?(cnpj, strict: true) }
  validate -> { errors.add(:tipo, "Categoria nao valida") unless ["Universidade", "Escola", "Creche"].include?(tipo) }
  validate :user_has_student, on: [:edit, :update]

  def user_has_student
    errors.add(:user_id, "Usuario já foi atribuido a um Aluno") unless
    User.find(user_id).student == nil
  end

  def change_user_id(user)
    @user = user
    update!(user_id: @user.id)
    @user.update!(user_type: "Institution")
  end
end
