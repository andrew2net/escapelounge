class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && action_name == "new"
      "devise"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    games_path
  end

  def configure_permitted_parameters
    added_attrs = %i[:name :email :password :password_confirmation :admin]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
