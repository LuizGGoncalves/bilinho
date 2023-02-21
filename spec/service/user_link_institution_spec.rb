require 'rails_helper'

RSpec.describe UserLinkInstitution, type: :model do
  it 'link user to institution' do
    @user = create(:user)
    @institution = create(:institution)
    response = UserLinkInstitution.call(@user, @institution.id)
    expect(response[:body].user_id).to eq(@user.id)
  end
  it 'user alredy linked to student' do
    @user = create(:user)
    @institution = create(:institution)
    @student = create(:student)
    @student.update!(user_id: @user.id)
    response = UserLinkInstitution.call(@user, @institution.id)
    expect(response[:status]).to eq 400
  end
end
