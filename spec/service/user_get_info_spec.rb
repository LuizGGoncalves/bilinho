require 'rails_helper'

RSpec.describe UserGetInfo, type: :model do
  it 'get student information' do
    @user = create(:user)
    @student = create(:student, user: @user)
    response = UserGetInfo.call(@user)
    expect(response[:body]).to eq(@student)
    expect(response[:status]).to eq(200)
  end
  it 'get institution information' do
    @user = create(:user, :institution_user)
    @institution = create(:institution, users: [@user])
    response = UserGetInfo.call(@user)
    expect(response[:body]).to eq(@institution)
    expect(response[:status]).to eq(200)
  end
  it 'Institution not linked' do
    @user = create(:user, :institution_user)
    @institution = create(:institution)
    response = UserGetInfo.call(@user)
    expect(response[:body][:errors]).to eq('Informaçoes da instituiçao nao vinculada')
    expect(response[:status]).to eq(400)
  end
  it 'Student not linked' do
    @user = create(:user)
    @student = create(:student)
    response = UserGetInfo.call(@user)
    expect(response[:body][:errors]).to eq('Informaçoes do estudante nao cadastradas')
    expect(response[:status]).to eq(400)
  end
end
