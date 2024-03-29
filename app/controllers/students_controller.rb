class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:register_update_student_info]
  before_action :check_admin, only: [:destroy, :index, :show, :create, :update]

  def register_update_student_info
    response = UserCreateUpdateStudent.call(current_user, student_params)
    render json: response[:body], status: response[:status]
  end

  def index
    @students = Student.all
    render json: @students
  end

  def show
    render json: @student
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      render json: @student, status: :created
    else
      render json: @student.errors, status: 400
    end
  end

  def edit; end

  def update
    if @student.update(student_params)
      render json: @student, status: 202
    else
      render json: @student.errors, status: 400
    end
  end

  def destroy
    if @student.destroy
      render json: @student, status: 202
    else
      render json: { errors: 'nao foi possivel deletar o estudante' }, status: 400
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.permit(:nome, :cpf, :data_nascimento, :telefone, :genero, :meio_pagamento, :user_id)
  end
end
