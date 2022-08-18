class UsersController < DeviseTokenAuth::RegistrationsController
  before_action :check_sing_in

  def self_info
    @user = current_user
    if @user.user_type == "Student"
      @student = @user.student
      if @student == nil
        return render json: {errors: "Informaçoes do estudante nao cadastradas"} 
      else
        return render json: @student
      end
    end
    if @user.user_type == "Institution"
      @institution = @user.institution
      if @institution == nil
        return render json: {errors: "Informaçoes do estudante nao cadastradas"} 
      else
        return render json: @institution
      end
    end
  end
end
