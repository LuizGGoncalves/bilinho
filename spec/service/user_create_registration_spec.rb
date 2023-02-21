require 'rails_helper'

RSpec.describe UserCreateRegistration, type: :model do
  it 'User create registration' do
    user = create(:user)
    institution = create(:institution)
    student = create(:student)
    student.change_user_id(user)
    params = {
      valor_total: 500,
      quantidade_faturas: 5,
      vencimento: 20,
      nome_curso: 'TesteCurso',
    }
    response = UserCreateRegistration.call(user, params, institution.id)
    expect(response[:body].valor_total).to eq(500)
    expect(response[:body].quantidade_faturas).to eq(5)
    expect(response[:body].vencimento).to eq(20)
    expect(response[:body].nome_curso).to eq('TesteCurso')
    expect(response[:status]).to eq(201)
  end
  it 'Not valid registration parameters' do
    user = create(:user)
    institution = create(:institution)
    student = create(:student)
    student.change_user_id(user)
    params = {
      valor_total: "string",
      quantidade_faturas: 50.6,
      vencimento: 50,
      nome_curso: 225,
    }
    response = UserCreateRegistration.call(user, params, institution.id)
    expect(response[:status]).to eq(400)
  end
end
