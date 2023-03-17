class User < ApplicationRecord
  # Include default devise modules.:omniauthable

  devise :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one :user_association, class_name: "Association"
  has_one :institution, through: :user_association, source: :associationable, source_type: 'Institution'
  has_one :student, through: :user_association, source: :associationable, source_type: 'Student'

  validates :user_type, presence: true
  validate -> { errors.add(:user_type, "Tipo nao valido") unless ["Student", "Institution"].include?(user_type) }

  before_save :set_user_role
  before_create :set_user_role

  def set_user_role
    return if self.roles.any? { |role| ["ADMIN"].include?(role) }
    if user_type.downcase == "student" then self.roles = ["STUDENT"] end
    if user_type.downcase == "institution" then self.roles = ["INSTITUTION"] end
  end
end
