class UserCreateUpdateStudent < ApplicationService
  def initialize(user, params)
    @user = user
    @student_params = params
  end

  def call
    register_update_student_info
  end

  private

  def register_update_student_info
    if @user.student.nil?
      @student = Student.new(@student_params)
      @student.user_id = @user.id
      if @student.save
        return { body: @student, status: 200 }
      else
        return { body: @student.errors, status: 400 }
      end
    else
      @student = @user.student
      if @student.update(@student_params)
        return { body: @student, status: 200 }
      else
        return { body: @student.errors, status: 400 }
      end
    end
  end
end
