# frozen_string_literal: true

# Uesr password controooler
class User::PasswordsController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(_resource_name)
    games_path
  end

  def after_resetting_password_path_for(_resource_name)
    games_path
  end
end
