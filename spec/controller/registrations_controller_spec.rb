require 'rails_helper'
RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user, roles: [ 'ADMIN']) }
  let(:student ) { create(:student) }
  let(:institution) { create(:institution) }
  let(:registration) { create(:registration, student: student, institution: institution)}

  describe "GET #index" do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return all registations' do
        get :index
        expect(response.status).to eq 200
        expect(response.body).to eq Registration.all.to_json
      end

    end

    context 'when user is not logged in' do
      it 'should return 401' do
        get :index
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #show" do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'should return specifc registration' do
        get :show, params: { id: registration.id }
        expect(response.status).to eq 200
        expect(response.body).to eq registration.to_json
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        get :show, params: {id: registration.id}
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #create" do

    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      context 'when registration value is valid' do
        it 'should create a new registration' do
          post :create, params: {
            valor_total: 1200,
            quantidade_faturas: 3,
            vencimento: 15,
            nome_curso: "testeCurso",
            institution_id: institution.id,
            student_id: student.id
          }
          expect(response.status).to eq 201
          expect(response.body).to eq Registration.last.to_json
        end
      end

      context 'when registration value is invalid' do
        it 'should create a new registration' do
          post :create, params: {
            valor_total: 1200,
            quantidade_faturas: 0,
            vencimento: 15,
            nome_curso: "testeCurso",
            institution_id: institution.id,
            student_id: student.id
          }
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'shoudl return 401' do
        post :create, params: {
          valor_total: 1200,
          quantidade_faturas: 3,
          vencimento: 15,
          nome_curso: "testeCurso"
        }
        expect(response.status).to eq 401
      end
    end


  end

  describe "PUT #update" do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      context 'when registration params is valid' do
        it 'should update the registrations' do
          put :update, params: { id: registration.id, nome_curso: 'novo nome'}
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['nome_curso']).to eq 'novo nome'
        end
      end

      context 'when registration params is invalid' do
        it 'should return the errors' do
          put :update, params: { id: registration.id, quantidade_faturas: 'teste'}
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        put :update, params: { id: registration.id, nome_curso: 'novo nome' }
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before do
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      context 'when destroy works' do
        it 'should destroy registration' do
          delete :destroy, params: { id: registration.id}
          expect(response.status).to eq 200
          expect(response.body).to eq registration.to_json
          expect(Registration.all.count).to eq 0
        end
      end

      context 'when destroy raise and error' do
        before do
          allow_any_instance_of(Registration).to receive(:destroy).and_raise(StandardError)
        end

        it 'should raise and error' do
          delete :destroy, params:{id: registration.id}
          expect(response.status).to eq 400
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        delete :destroy, params: { id: registration.id }
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET #user_registrations' do

    context 'when user is logged in' do
      before do
        student.change_user(user)
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'should return user registrations' do
        get :user_registrations
        expect(response.status).to eq 200
        expect(response.body).to eq Registration.where(student_id: student.id).to_json
      end
    end

    context 'when user is not logged in' do
      it 'should reutnr 401' do
        get :user_registrations
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #user_create_registration' do
    context 'when user is logged in' do
      before do
        student.change_user(user)
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'should create a new registration' do
        get :user_create_registration, params: {
          valor_total: 1800,
          quantidade_faturas: 3,
          vencimento: 15,
          nome_curso: "testeCurso",
          instId: institution.id
        }
        expect(response.status).to eq 201
        expect(JSON.parse(response.body)['valor_total']).to eq 1800
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        get :user_create_registration, params: {
            valor_total: 1200,
            quantidade_faturas: 3,
            vencimento: 15,
            nome_curso: "testeCurso",
            instId: institution.id
          }
        expect(response.status).to eq 401
      end
    end
  end
end