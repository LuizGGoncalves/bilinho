require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let(:user) { create(:user,roles: ['ADMIN']) }
  let!(:student) { create(:student, user: user) }
  let(:user_2) { create(:user) }
  let!(:student_2) { create(:student, user: user_2) }

  describe 'PUT #register_update_student_info' do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should call service and return  200' do
        allow(UserCreateUpdateStudent).to receive(:call).and_return({body: 'teste', status: 200 })
        put :register_update_student_info, params: { nome: 'teste'}
        expect(response.status).to eq 200
        expect(response.body).to eq 'teste'
      end
    end

    context 'when user dont have permission' do
      let!(:user) { create(:user, :institution_user) }

      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'should return 401' do
        put :register_update_student_info, params: { nome: 'teste' }
        expect(response.status).to eq 401
      end

    end

    context 'when user is not logged in' do
      it 'retuns erro 401' do
        put :register_update_student_info, params: { nome: 'teste'}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET #index' do

    context "when user is admin" do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'Return all students' do
        get :index
        expect(response.body).to eq([student, student_2].to_json)
        expect(response.status).to eq(200)
      end
    end

    context "when user is not admin" do
      let(:user) { create(:user) }
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "should return 401" do
        get :index
        expect(JSON.parse(response.body)["errors"]).to eq("Nao possui permissao")
        expect(response.status).to eq(401)
      end
    end

  end

  describe 'GET #show' do

    context 'when user is Admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'Return specif students' do
        get :show, params: { id: student.id}
        expect(response.body).to eq(student.to_json)
        expect(response.status).to eq(200)
      end
    end

    context 'when user is not Admin' do
      !let(:user) { create(:user) }
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return 401' do
        get :show, params: { id: student.id}
        expect(JSON.parse(response.body)["errors"]).to eq("Nao possui permissao")
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST #create' do
    let!(:user_base) { create(:user) }
    context 'When user is admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      context 'When student params is valid' do
        it "should create a new student" do
          student_params = {
            nome: 'pedrinho',
            cpf: '470.223.140-55',
            data_nascimento: '1990-11-12',
            genero: 'M',
            meio_pagamento: 'cartao',
            telefone: '11_111_111',
            user_id: user_base.id
          }
          post :create, params: student_params
          expect(response.status).to eq 201
          expect(response.body).to eq(Student.last.to_json)
        end
      end
      context 'When Student params is invalid' do
        it 'Should return badRquest' do
          student_params = {
            nome: 'pedrinho',
            cpf: '470',
            data_nascimento: '1990-11-12',
            genero: 'P',
            meio_pagamento: 'cartao',
            telefone: '11_111_111',
            user_id: user_base.id
          }
          post :create, params: student_params
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not admin' do
      !let(:user) { create(:user) }
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return 401' do
        post :create, params: { nome: 'teste'}
        expect(JSON.parse(response.body)["errors"]).to eq("Nao possui permissao")
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      context 'when student params is valid' do
        it 'should update student' do
            student_params = {
              id: student.id,
              nome: 'pedrinho'
            }
          put :update, params: student_params
          expect(response.status).to eq(202)
          expect(Student.find(student.id).nome).to eq('pedrinho')
        end
      end
      context 'when student params is invalid' do
        it 'should raise an error' do
          student_params = {
            id: student.id,
            cpf: '4548654564859564546849'
          }
          put :update, params: student_params
          expect(response.status).to eq(400)
        end


      end
    end

    context 'when user is not admin' do
      !let(:user) { create(:user) }
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return 401' do
        student_params = {
          id: student.id,
          nome: 'pedrinho'
        }
        put :update, params: student_params
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is admin' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      context 'when select user exists' do
        it 'should destroy user' do
          delete :destroy, params:  { id: student.id }
          expect(response.status).to eq(202)
          expect(Student.find_by_id(student.id)).to eq(nil)
        end
      end
      context 'when user select dont exist' do
        it 'should return error' do
          delete :destroy, params:  { id: 123 }
          expect(response.status).to eq(400)
        end
      end
      context 'when a unexpected erro happens' do
        before do
          allow_any_instance_of(Student).to receive(:destroy).and_raise(StandardError)
        end

        it 'returns a 400' do
          delete :destroy, params: { id: student.id }
          expect(response.status).to eq(400)
        end
      end
    end

    context 'when user is not admin' do
      !let(:user) { create(:user) }
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return  401 ' do
        delete :destroy, params:  { id: student.id }
        expect(response.status).to eq(401)
      end
    end
  end
end