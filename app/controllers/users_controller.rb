class UsersController < DeviseTokenAuth::RegistrationsController
  before_action :check_sing_in

  def self_info
    response = UserGetInfo.call(current_user)
    render json: response[:body], status: response[:status]
  end
end
