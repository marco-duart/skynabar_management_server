class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Devise::Controllers::Helpers
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :disable_session

  private

  def disable_session
    request.session_options[:skip] = true
  end
end
