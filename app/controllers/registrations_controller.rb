class RegistrationsController < ApplicationController
  before_action :set_registration, only: %i[show edit update destroy]
  before_action :check_user, only: %i[user_create_registration]
  before_action :check_admin, only: %i[index show create destroy update]

  def user_create_registration
    @user = current_user
    @registration = Registration.new(registration_params)
    @registration.student_id = @user.student.id
    @registration.institution_id = params[:instId]
    if @registration.save
      create_bills(@registration)
      render json: @registration, status: :created
    else
      render json: @registration.errors, status: 400
    end
  end

  def user_registrations
    @user = current_user
    if @user.user_type == "Student"
      if @user.student == nil then render json: {errors: "Usuario nao vinculado!"} end
      registrations = @user.student.registrations
      render json: registrations, status: 200
    end
    if @user.user_type == "Institution"
      if @user.institution == nil then render json: {errors: "Usuario nao vinculado!"} end
      registrations = @user.institution.registrations
      render json: registrations, status: 200
    end
  end

  def index
    @registrations = Registration.all
    render :json => @registrations 
  end

  def show 
    render :json => @registration
  end

  def new
    @registration = Registration.new
  end

  def edit
  end

  def create
    @registration = Registration.new(registration_params)

    if @registration.save 
      create_bills(@registration)
      render json: @registration, status: :created
    else
      render json: @registration.errors, status: 400
    end
  end

  def update 
    if @registration.update(registration_params)
      render json: @registration, status: 200
    else
      rrender json: @registration.errors, status: 400
    end
  end

  def destroy 
    if @registration.destroy
      render json: @registration, status: 200
    else
      render json: {errors: "nao foi possivel deletar"}, status: 400
    end
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def registration_params
    params.permit(:valor_total, :quantidade_faturas, :vencimento, :nome_curso, :institution_id, :student_id)
  end

  def create_bills(registration)
    count = 0
    today = Date.today
    registration.quantidade_faturas.times {
      bill_value = registration.valor_total / registration.quantidade_faturas
      if count == 0 && registration.vencimento < today.mday
        date = Date.new(today.year, today.mon, 10)
        Bill.new(valor_fatura: bill_value, data_vencimento: date, registration_id: 2, status: "Aberta").save
        count += 1
      else
        date = today + count.months
        if date.mon == 2 && registration.vencimento > 29
          if date.leap?
            date = date.change(day: 29)
          else
            date = date.change(day: 28)
          end
        elsif [4, 6, 9, 11 ].include?(date.mon) && registration.vencimento > 30
          date = date.change(day: 30)
        else
          date = date.change(day: registration.vencimento)
        end
        Bill.new(valor_fatura: bill_value, data_vencimento: date, registration_id: @registration.id, status: "Aberta").save
        count +=  1
      end
    }
  end
end
