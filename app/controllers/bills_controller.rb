class BillsController < ApplicationController
  before_action :set_bill, only: %i[show edit update destroy]
  before_action :check_sing_in, only: %i[show_user_bill]
  before_action :check_admin, only: %i[index show create destroy update]

  def show_user_bill
    response = UserGetBills.call(current_user)
    render json: response[:body], status: response[:status]
  end

  def index 
    @bills = Bill.all
    render json: @bills
  end

  def show
    render json: @bills
  end

  def new
    @bill = Bill.new
  end

  def create 
    @bill = Bill.new(bill_params)
    if @bill.save
      render json: @bill, status: 202
    else
      render json: @bill.errors, status: 400
    end
  end

  def edit 
  end

  def update 
    if @bill.update(bill_params)
      render json: @bill, status: 200
    else
      render json: @bill.errors, status: 400
    end
  end

  def destroy
    if @Bill.destroy
      render json: @Bill, status:202
    else
      render json: {errors: "nao foi possivel deletar a mensalidade"}, status:400
    end
  end

  private

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def bill_params 
    params.permit(:valor_fatura, :data_vencimento, :registration_id, :status)
  end
end