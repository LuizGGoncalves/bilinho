require 'rails_helper'

RSpec.describe Student, type: :model do
  it 'set_user_id' do
    @user = create(:user)
    @student = create(:student)
    @student.change_user_id(@user)
    expect(User.find(@user.id).user_type).to eq('Student')
    expect(User.find(@user.id).student).to eq(@student)
  end
end
