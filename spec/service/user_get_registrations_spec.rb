require 'rails_helper'

RSpec.describe UserGetRegistrations, type: :model do
  it 'Student account get registrations' do
    @user = create(:user)
    @institution = create(:institution)
    @student = create(:student)
    registration_array = []
    @student.change_user_id(@user)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)

    response = UserGetRegistrations.call(@user)
    expect(response[:body]).to eq(registration_array)
    expect(response[:status]).to eq(200)
  end

  it "Institution account get registration" do
    @user = create(:user)
    @institution = create(:institution)
    @institution.change_user_id(@user)
    @student = create(:student)
    registration_array = []
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)

    response = UserGetRegistrations.call(@user)
    expect(response[:body]).to eq(registration_array)
    expect(response[:status]).to eq(200)
  end

  it 'student account not linked' do
    @user = create(:user)
    @institution = create(:institution)
    @student = create(:student)
    registration_array = []
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)

    response = UserGetRegistrations.call(@user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado a um estudante!')
    expect(response[:status]).to eq(400)
  end

  it 'institution account not linked' do
    @user = create(:user, :institution_user)
    @institution = create(:institution)
    @student = create(:student)
    registration_array = []
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)

    response = UserGetRegistrations.call(@user)
    expect(response[:body][:errors]).to eq('Usuario nao vinculado a uma instituiçao!')
    expect(response[:status]).to eq(400)
  end
end
