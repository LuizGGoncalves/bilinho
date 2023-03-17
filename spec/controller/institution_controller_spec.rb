require 'rails_helper'

RSpec.describe InstitutionsController, type: :controller do
  let!(:inst_user) { create(:user, :institution_user, roles: ['ADMIN']) }
  let!(:institution) { create(:institution, users: [inst_user]) }

  describe "GET #index" do

    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end
      it 'should return a list of all institution ' do
        get :index
        expect(response.status).to eq 200
        expect(response.body).to eq Institution.all.to_json
      end
    end

    context 'when user is not logged in' do
      it 'should return 401'do
      get :index
      expect(response.status).to eq 401
      end
    end
  end

  describe "GET #show" do
    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it 'should return the specified institutiton' do
        get :show, params: { id: institution.id }
        expect(response.status).to eq 200
        expect(response.body).to eq institution.to_json
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        get :show, params: { id: institution.id}
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #create" do
    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it 'should create a new institution' do
        post :create, params: { nome: 'teste', cnpj: '49553711000182', tipo: 'Universidade' }
        expect(response.status).to eq 201
        expect(response.body).to eq Institution.last.to_json
      end

      context 'when institution value is invalid' do
        it 'should return an error' do
          post :create, params: { nome: 'teste', cnpj: '49553711056182', tipo: 'Universidade' }
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        post :create, params: { nome: 'teste', cnpj: '16465209000160', tipo: 'Universidade' }
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it 'should update intitution' do
        put :update, params: {id: institution.id, nome: 'testando' }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['nome']).to eq Institution.last.nome
      end

      context 'when institution value is invalid' do
        it 'should raise and error' do
          put :update, params: {id: institution.id, cnpj: '15465148656' }
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        put :update, params: {id: institution.id, nome: 'testando' }
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      let(:institution_id) { institution.id}
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it 'should delete the institution' do
        delete :destroy, params: { id: institution.id }
        expect(response.status).to eq 200
        expect(Institution.find_by(id: institution_id)).to be(nil)
      end

      context 'when delete raise error' do
        before do
          allow_any_instance_of(Institution).to receive(:destroy).and_raise(StandardError)
        end
        it 'should raise an error' do
          delete :destroy, params: { id: institution.id }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['errors']).to eq 'nao foi possivel deletar a instituiçao'
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        delete :destroy, params: { id: institution.id }
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PUT #self_info_update' do
    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it'should update user institution' do
        put :self_info_update, params: { name: 'novo nome'}
        expect(response.status).to eq 200
        expect(response.body).to eq Institution.last.to_json
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
      put :self_info_update, params: { name: 'novo nome' }
      expect(response.status).to eq 401
      end
    end
  end

  describe 'PUT #link_user_to_institutions' do
    context 'when user is logged in' do
      before do
        sign_in inst_user
        allow(controller).to receive(:current_user).and_return(inst_user)
      end

      it 'should link user to institution' do
        put :link_user_to_institutions, params: { id: institution.id }
        expect(response.status).to eq 200
        expect(response.body).to eq "Sucess #{inst_user.id} linked to Institution testeInstitution"
      end

      context 'when error happen' do
        before do
          allow_any_instance_of(Institution).to receive(:add_user).and_raise(RuntimeError)
        end
        it 'should return 400' do
          put :link_user_to_institutions, params: { id: institution.id }
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        put :link_user_to_institutions, params: { id: institution.id}
        expect(response.status).to eq 401
      end
    end
  end
end