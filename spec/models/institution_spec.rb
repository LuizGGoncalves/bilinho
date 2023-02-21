require 'rails_helper'

RSpec.describe Institution, type: :model do
  it 'set_user_id' do
    @user = create(:user)
    @institution = create(:institution)
    @institution.change_user_id(@user)
    expect(User.find(@user.id).user_type).to eq('Institution')
    expect(User.find(@user.id).institution).to eq(@institution)
  end
end
