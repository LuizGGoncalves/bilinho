require 'rails_helper'

RSpec.describe UserGetBills, type: :model do
  it 'Get Stundent bills' do
    @user = create(:user)
    @student = create(:student)
    @institution = create(:institution)
    @student.change_user_id(@user)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    @bills = {}
    @bills[@registration.id] = @registration.bills
    response = UserGetBills.call(@user)
    expect(response[:body]).to eq(@bills)
  end

  it 'Get Institution bills ' do
    @user = create(:user)
    @student = create(:student)
    @institution = create(:institution)
    @institution.change_user_id(@user)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    @bills = {}
    @bills[@registration.id] = @registration.bills
    response = UserGetBills.call(@user)
    expect(response[:body]).to eq(@bills)
  end

  it 'Institution not linked' do
    @user = create(:user)
    @student = create(:student)
    @institution = create(:institution)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    @bills = {}
    @bills[@registration.id] = @registration.bills
    response = UserGetBills.call(@user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado!')
    expect(response[:status]).to eq(400)
  end

  it 'Institution not linked' do
    @user = create(:user, :institution_user)
    @student = create(:student)
    @institution = create(:institution)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    @bills = {}
    @bills[@registration.id] = @registration.bills
    response = UserGetBills.call(@user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado!')
    expect(response[:status]).to eq(400)
  end
end
