class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]
  before_action :check_user, only: %i[register_update_student_info]
  before_action :check_admin, only: %i[destroy index show create update]

  def register_update_student_info
    @user = current_user
    if @user.student == nil
      @student = Student.new(student_params)
      @student.user_id = @user.id
      if @student.save
        render json: @student ,status: :created
      else
        render json: @student.errors, status: 400
      end
    else
      @student = @user.student
      if @student.update(student_params)
        render json: @student, status: 202
      else
        render json: @student.errors, status: 400
      end
    end
  end

  def index
    @students = Student.all
    render :json => @students
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

  def edit 
  end

  def update
    if @student.update(student_params)
      render json: @student, status: 202
    else
      render json: @student.errors, status: 400
    end
  end

  def destroy
    if @student.destroy
      render json: @student, status:202
    else
      render json: {errors: "nao foi possivel deletar o estudante"}, status:400
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