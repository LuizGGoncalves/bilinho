class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:user_create_registration]
  before_action :check_admin, only: [:index, :show, :create, :destroy, :update]

  def user_create_registration
    response = UserCreateRegistration.call(current_user, registration_params, params[:instId])
    render json: response[:body], status: response[:status]
  end

  def user_registrations
    response = UserGetRegistrations.call(current_user)
    render json: response[:body], status: response[:status]
  end

  def index
    @registrations = Registration.all
    render json: @registrations
  end

  def show
    render json: @registration
  end

  def new
    @registration = Registration.new
  end

  def edit; end

  def create
    @registration = Registration.new(registration_params)

    if @registration.save
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
      render json: { errors: 'nao foi possivel deletar' }, status: 400
    end
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def registration_params
    params.permit(:valor_total, :quantidade_faturas, :vencimento, :nome_curso, :institution_id, :student_id)
  end
end
