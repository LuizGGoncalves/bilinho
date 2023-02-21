class UserGetInfo < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    self_info
  end

  private

  def self_info
    if @user.user_type == 'Student'
      @student = @user.student
      if @student.nil?
        return { body: { errors: 'Informaçoes do estudante nao cadastradas' }, status: 400 }
      else
        return { body: @student, status: 200 }
      end
    end
    if @user.user_type == 'Institution'
      @institution = @user.institution
      if @institution.nil?
        { body: { errors: 'Informaçoes da instituiçao nao vinculada' }, status: 400 }
      else
        { body: @institution, status: 200 }
      end
    end
  end
end
