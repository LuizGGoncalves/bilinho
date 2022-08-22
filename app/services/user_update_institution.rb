class UserUpdateInstitution < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    self_info_update
  end

  private

  def self_info_update
    @institution = @user.institution
    return { body: { errors: 'Usuario nao vinculado!' }, status: 400 } if @institution.nil?

    if @institution.update(user_insttitution_params)
      { body: @institution, status: 200 }
    else
      { body: @institution.errors, status: 400 }
    end
  end
end
