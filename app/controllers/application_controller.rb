class ApplicationController < ActionController::Base
  private

  def authenticate_admin
    if user_signed_in?
      return if current_user.admin?

      redirect_to root_path, alert: 'Necessita privilégios de administrador'
    else
      redirect_to new_user_session_path, alert: 'Para continuar, faça login ou registre-se.'
    end
  end

  def authenticate_status
    return if current_user.active?

    redirect_to root_path, alert: 'Vendedor com status inativo, contate um administrador'
  end
end
