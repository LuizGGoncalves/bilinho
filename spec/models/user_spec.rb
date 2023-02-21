require 'rails_helper'

RSpec.describe User, type: :model do
  it 'changin user_type to institution' do
    @user = create(:user)
    @user.update!(user_type: 'Institution')
    expect(@user.user_type).to eq('Institution')
    expect(@user.roles).to eq(['INSTITUTION'])
  end

  it 'changin user_type to student' do
    @user = create(:user)
    @user.update!(user_type: 'Institution')
    @user.update!(user_type: 'Student')
    expect(@user.user_type).to eq('Student')
    expect(@user.roles).to eq(['STUDENT'])
  end
end
