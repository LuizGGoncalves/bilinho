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
      return { body: { errors: 'Usuario nao vinculado a um estudante!' }, status: 400 } if @user.student.nil?

      registrations = @user.student.registrations
      return { body: registrations, status: 200 }
    end
    if @user.user_type == 'Institution'
      return { body: { errors: 'Usuario nao vinculado a uma instituiçao!' }, status: 400 } if @user.institution.nil?

      registrations = @user.institution.registrations
      { body: registrations, status: 200 }
    end
  end
end
