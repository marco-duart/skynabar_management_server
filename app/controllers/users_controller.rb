class UsersController < DeviseTokenAuth::ApplicationController
  before_action :authenticate_user!

  def me
    render json: {
      data: {
        user: current_user.as_json(only: [ :id, :name, :email, :document, :role ])
      }
    }, status: :ok
  end
end
