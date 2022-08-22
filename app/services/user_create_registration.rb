class UserCreateRegistration < ApplicationService
  def initialize(user, params, inst_id)
    @user = user
    @registration_params = params
    @inst_id = inst_id
  end

  def call
    user_create_registration
  end

  private

  def user_create_registration
    @registration = Registration.new(@registration_params)
    @registration.student_id = @user.student.id
    @registration.institution_id = @inst_id
    if @registration.save
      CreateBills.call(@registration)
      { body: @registration, status: :created }
    else
      { body: @registration.errors, status: 400 }
    end
  end
end
