require 'rails_helper'

RSpec.describe UserGetRegistrations, type: :model do
  it 'should get user registrations' do
    @user = create(:user)
    @institution = create(:institution)
    @student = create(:student)
    registration_array = []
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @registration = create(:registration, institution_id: @institution.id, student_id: @student.id)
    registration_array.push(@registration)
    @student.update!(user_id: @user.id)
    response = UserGetRegistrations.call(@user)
    expect(response[:body]).to eq(registration_array)
    expect(response[:status]).to eq(200)
  end
end
