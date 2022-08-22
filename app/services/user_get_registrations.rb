class UserGetRegistrations < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    user_registrations
  end

  private

  def user_registrations
    if @user.user_type == 'Student'
      return { errors: 'Usuario nao vinculado!' } if @user.student.nil?

      registrations = @user.student.registrations
      return { body: registrations, status: 200 }
    end
    if @user.user_type == 'Institution'
      return { errors: 'Usuario nao vinculado!' } if @user.institution.nil?

      registrations = @user.institution.registrations
      { body: registrations, status: 200 }
    end
  end
end
