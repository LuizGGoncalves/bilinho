require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #self_info' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      let!(:student) { create(:student, user: user) }

      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
        get :self_info
      end

      it 'Should return status 200' do
        expect(response.status).to eq(200)
      end

      it 'Should return user info in JSON format' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(JSON.parse(response.body)["nome"]).to eq(student.nome)
      end
    end

    context 'when user is not logged in' do
      before do
        get :self_info
      end

      it "returns not autorized" do
        expect(response.status).to eq 401
      end
    end
  end
end
