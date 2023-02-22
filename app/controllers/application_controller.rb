class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [{ roles: [] }, :name, :nickname])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_type, :name, :nickname])
  end

  def check_sing_in
    if user_signed_in? == false then return render json: { errors: "Realizar login" }, status: 400 end
    authenticate_user!
    @user = current_user
    return render json: { errors: "Nao possui permissao" } unless
    @user.roles.any? { |role| ["STUDENT", "ADMIN", "INSTITUTION"].include?(role) }
  end

  def check_user
    if user_signed_in? == false then return render json: { errors: "Realizar login" } end
    authenticate_user!
    @user = current_user
    return render json: { errors: "Nao possui permissao" } unless
    @user.roles.any? { |role| ["STUDENT", "ADMIN"].include?(role) }
  end

  def check_institutions
    if user_signed_in? == false then return render json: { errors: "Realizar login" } end
    authenticate_user!
    @user = current_user
    return render json: { errors: "Nao possui permissao" } unless
    @user.roles.any? { |role| ["INSTITUTION", "ADMIN"].include?(role) }
  end

  def check_admin
    if user_signed_in? == false then return render json: { errors: "Realizar login" } end
    authenticate_user!
    @user = current_user
    return render json: { errors: "Nao possui permissao" } unless
    @user.roles.any? { |role| ["ADMIN"].include?(role) }
  end
end
