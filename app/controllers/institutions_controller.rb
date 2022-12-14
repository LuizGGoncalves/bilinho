class InstitutionsController < ApplicationController
  before_action :set_institution, only: %i[show edit update destroy]
  before_action :check_sing_in, only: %i[index show]
  before_action :check_institutions, only: %i[link_user_to_institutions self_info_update]
  before_action :check_admin, only: %i[destroy create edit update]

 def link_user_to_institutions
   @user = current_user
   @institution = Institution.find(params[:id])
   @institution.user_id = @user.id
   if @institution.save 
    render json: @institution, status: 200
   else
    render json: @institution.errors, status: 400
   end
 end

 def self_info_update 
   @institution = current_user.institution
   if @institution == nil then return render json: {errors: "Usuario nao vinculado!"} end
   if @institution.update(user_insttitution_params)
     render json: @institution, status: 200
   else
     render json: @institution.errors, status: 400
   end
 end

  def index
    @institutions = Institution.all
    print current_user.name
    render json: @institutions
  end

  def show
    render json: @institution
  end

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.new(institution_params)
    if @institution.save
      render json: @institution, status: :created
    else
      render json: @institution.errors, status: 400
    end
  end

  def edit
  end

  def update
    if @institution.update(institution_params)
      render json: @institution, status: 202
    else
      render json: @institution.errors, status: 400
    end
  end

  def destroy
    if @institution.destroy
      render json: @institution, status:202
    else
      render json: {errors: "nao foi possivel deletar a instituiçao"}, status:400
    end
  end

  private

  def set_institution
    @institution = Institution.find(params[:id])
  end

  def institution_params
    params.permit(:nome, :cnpj, :tipo, :user_id)
  end

  def user_insttitution_params
    params.permit(:nome, :tipo)
  end
end
