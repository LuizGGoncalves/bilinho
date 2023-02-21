class UserUpdateInstitution < ApplicationService
  def initialize(user,user_institution_params)
    @user = user
    @user_institution_params = user_institution_params
  end

  def call
    self_info_update
  end

  private

  def self_info_update
    @institution = @user.institution
    return { body: { errors: 'Institutiçao nao vinculado!' }, status: 400 } if @institution.nil?

    if @institution.update(@user_institution_params)
      { body: @institution, status: 200 }
    else
      { body: @institution.errors, status: 400 }
    end
  end
end
