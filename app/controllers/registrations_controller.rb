class RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :configure_permitted_parameters, only: [ :create ]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :document, :role ])
  end
end
