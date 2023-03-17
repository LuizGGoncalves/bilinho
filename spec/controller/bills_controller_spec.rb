require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  let(:user) { create(:user,roles: ['ADMIN']) }
  let(:student) { create(:student, user: user) }
  let(:inst_user) { create(:user, :institution_user) }
  let(:institution) { create(:institution, users: [inst_user]) }
  let!(:registration) { create(:registration, student: student, institution: institution)}

  describe "GET #show_user_bill" do
    context 'when user is logged in' do
      context 'when user is student' do
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'should return user all bills' do
          get :show_user_bill
          expect(response.status).to eq 200
          expect(response.body).to eq registration.bills.to_json
        end
      end

      context 'when user is institution' do
        let(:student2) { create(:student)}
        let!(:registration2) { create(:registration, student: student2, institution: institution)}
        before do
          sign_in inst_user
          allow(controller).to receive(:current_user).and_return(inst_user)
        end

        it'should return institution all bills' do
          get :show_user_bill
          expect(response.body).to eq (registration.bills + registration2.bills).to_json
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        get :show_user_bill
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #index" do

    context "when user is logged in" do

      context 'when user have permissions' do
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'return all bills' do
          get :index
          expect(response.status).to eq (200)
          expect(response.body).to eq(Bill.all.to_json)
        end

      end

      context 'when user dont have permissions' do
        let(:user) { create(:user) }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'should return 401' do
          get :index
          expect(response.status).to eq (401)
        end
      end
    end

    context "when user is not logged in" do

      it ' should return 401' do
        get :index
        expect(response.status).to eq (401)
      end
    end
  end

  describe "GET #show" do

    context 'when user is logged in' do

      context 'wher user have permission' do
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'should return spefic bill' do
          get :show, params: { id: Bill.last.id}
          expect(response.status).to eq 200
          expect(response.body).to eq( Bill.last.to_json )
        end
      end

      context 'when user dont have permission' do
        let!(:user) { create(:user) }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'should return 401' do
          get :show, params: { id: Bill.last.id}
          expect(response.status).to eq 401
        end
      end
    end

    context 'when user is not logged in' do

      it 'should return 401' do
        get :index, params: { id: Bill.last.id }
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #create" do

    context 'when user is logged in' do

      context 'when user have permission' do
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        context 'when params is valid' do
          it 'should create a new bill' do
            post :create, params: { valor_fatura: 100, data_vencimento: '2000-12-1', registration_id: registration.id, status: 'Paga' }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body)["valor_fatura"]).to eq 100
            expect(JSON.parse(response.body)["registration_id"]).to eq registration.id
          end
        end

        context 'when params is invalid' do
          it 'should create a new bill' do
            post :create, params: { valor_fatura: 0, data_vencimento: '2000-12-1', registration_id: registration.id, status: 'Velha' }
            expect(response.status).to eq 400
          end
        end
      end

      context 'when user dont have permission' do
        let(:user) { create(:user) }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end
        it 'should return 401' do
          post :create, params: { valor_fatura: 100, data_vencimento: '2000-12-1', registration_id: 1, status: 'Paga' }
          expect(response.status).to eq 401
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return 401' do
        post :create, params: { valor_fatura: 100, data_vencimento: '2000-12-1', registration_id: 1, status: 'Paga' }
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    context "when user is logged in" do

      context "when user have permission" do
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        context "when params is valid" do
          it "should update the specifed bill" do
            put :update, params: {id: Bill.last.id, valor_fatura: 956.25 }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)["valor_fatura"]).to eq( 956.25 )
          end
        end

        context 'when params is not valid' do
          it "should update the specifed bill" do
            put :update, params: {id: Bill.last.id, status: 'velha' }
            expect(response.status).to eq 400
          end
        end
      end

      context 'when user dont have permission' do
        let!(:user) { create(:user) }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        it "should reutn 401" do
          put :update, params: {id: Bill.last.id, valor_fatura: 956.25 }
          expect(response.status).to eq 401
        end
      end
    end

    context "when user is not logged in" do

      it 'should retunr 401' do
        put :update, params: {id: Bill.last.id, valor_fatura: 956.25 }
        expect(response.status).to eq 401
    end
    end
  end

  describe "DELETE #destroy" do
    context 'when user is logged in' do

      context 'when user have permission' do
        let(:bill_id) { Bill.last.id }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end

        context 'when destroy works' do
          it 'should delete the specified bill' do
            delete :destroy, params: { id: bill_id}
            expect(response.status).to eq 200
            expect(Bill.find_by(id: bill_id)).to be_nil
          end
        end

        context 'when destroy raise an error' do
          before do
            allow_any_instance_of(Bill).to receive(:destroy).and_raise(StandardError)
          end
          it 'should raise and error' do
            delete :destroy, params: { id: bill_id}
            expect(response.status).to eq 400
          end
        end

      end

      context 'when user dont have permission' do
        let(:user) { create(:user) }
        before do
          sign_in user
          allow(controller).to receive(:current_user).and_return(user)
        end
        it 'should return 401' do
          delete :destroy, params: { id: Bill.last.id }
          expect(response.status).to eq 401
        end
      end
    end

    context 'when user is not logged in' do

      it 'should reutn 401' do
        delete :destroy, params: { id: Bill.last.id}
        expect(response.status).to eq 401
      end
    end
  end
end