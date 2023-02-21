require 'rails_helper'

RSpec.describe UserUpdateInstitution, type: :model do
  it 'update institution name' do
    @user = create(:user, :institution_user)
    @institution = create(:institution)
    @institution.change_user_id(@user)
    institutions_params = {
      nome: 'alterado',
    }
    response = UserUpdateInstitution.call(@user, institutions_params)
    expect(response[:body].nome).to eq('alterado')
    expect(response[:status]).to eq(200)
  end
  it 'update institution id' do
    @user = create(:user, :institution_user)
    @institution = create(:institution)
    @institution.change_user_id(@user)
    institutions_params = {
      id: 25,
    }
    response = UserUpdateInstitution.call(@user, institutions_params)
    expect(response[:body].id).to eq(25)
    expect(response[:status]).to eq(200)
  end
  it 'Institution not linked' do
    @user = create(:user, :institution_user)
    institutions_params = {
      name: 'alterado',
    }
    response = UserUpdateInstitution.call(@user, institutions_params)
    expect(response[:body][:errors]).to eq('Institutiçao nao vinculado!')
    expect(response[:status]).to eq(400)
  end
end
