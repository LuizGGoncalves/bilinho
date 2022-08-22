class UserLinkInstitution < ApplicationService
  def initialize(user, inst_id)
    @user = user
    @ints_id = inst_id
  end

  def call
    link_user_to_institutions
  end

  private

  def link_user_to_institutions
    @institution = Institution.find(@inst_id)
    @institution.user_id = @user.id
    if @institution.save
      { body: @institution, status: 200 }
    else
      { body: @institution.errors, status: 400 }
    end
  end
end
