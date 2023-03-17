require 'rails_helper'

RSpec.describe UserGetBills, type: :model do
  it 'Get Student bills' do
    user = create(:user)
    student = create(:student, user: user)
    institution = create(:institution)
    registration = create(:registration, institution_id: institution.id, student_id: student.id)
    response = UserGetBills.call(user)
    expect(response[:body]).to eq(registration.bills)
  end

  it 'Get Institution bills ' do
    user = create(:user, :institution_user)
    student = create(:student)
    institution = create(:institution, users: [ user ])
    registration = create(:registration, institution_id: institution.id, student_id: student.id)
    response = UserGetBills.call(user)
    expect(response[:body]).to eq(registration.bills)
  end

  it 'Institution not linked' do
    user = create(:user)
    student = create(:student)
    institution = create(:institution)
    registration = create(:registration, institution_id: institution.id, student_id: student.id)
    response = UserGetBills.call(user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado!')
    expect(response[:status]).to eq(400)
  end

  it 'Institution not linked' do
    user = create(:user, :institution_user)
    student = create(:student)
    institution = create(:institution)
    registration = create(:registration, institution_id: institution.id, student_id: student.id)
    response = UserGetBills.call(user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado!')
    expect(response[:status]).to eq(400)
  end
end
