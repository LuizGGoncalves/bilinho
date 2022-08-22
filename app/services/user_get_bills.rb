class UserGetBills < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    show_user_bill
  end

  private

  def show_user_bill
    if @user.user_type == 'Student'
      return { body: { errors: 'Usuario nao vinculado!' }, status: 400 } if @user.student.nil?

      registrations = @user.student.registrations
      bills = {}
      registrations.each do |registration|
        bills[registration.id] = registration.bills
      end
      return { body: bills, status: 200 }
    end
    if @user.user_type == 'Institution'
      return { body: { errors: 'Usuario nao vinculado!' }, status: 400 } if @user.institution.nil?

      registrations = @user.institution.registrations
      bills = {}
      registrations.each do |registration|
        bills[registration.id] = registration.bills
      end
      return { body: bills, status: 200 }
    end
  end
end
