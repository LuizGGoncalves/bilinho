require 'rails_helper'

RSpec.describe CreateBillsService, type: :model do
  it 'teste data' do
    allow(Date).to receive(:today).and_return Date.new(2022, 1, 1)
    institution = create(:institution)
    student = create(:student)
    registration = create(:registration,
         institution_id: institution.id,
         student_id: student.id,
         valor_total: 500,
         quantidade_faturas: 5,
         vencimento: 15,
    )
    expect(Registration.find(registration.id).bills.size).to eq(5)
  end
end
