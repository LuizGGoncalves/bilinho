class Bill < ApplicationRecord
  belongs_to :registration
  after_initialize -> { self.status = "aberta" if self.status.nil? }, unless: :persisted?

  validates :valor_fatura, presence: true
  validates :data_vencimento, presence: true
  validates :registration_id, presence: true
  validates :status, presence: true

  validate -> { errors.add(:status, 'Status invalido') unless ['aberta', 'atrassada', 'paga'].include?(status.downcase) }
end
