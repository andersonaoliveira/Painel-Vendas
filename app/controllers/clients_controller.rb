class ClientsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :authenticate_admin, only: %i[review_deactivation deactivate_cpf activate_cpf]
  before_action :authenticate_status

  def index
    @clients = Client.where(eni_status: :active)
    @inactive_clients = Client.where(eni_status: :inactive)
  end

  def show
    @client = Client.find(params[:id])
  end

  def search
    @client = Client.find_by eni: params[:query]
    if @client
      redirect_to client_path(@client.id)
    else
      flash[:alert] = 'Cliente não encontrado'
      redirect_to clients_path
    end
  end

  def new
    @client = Client.new
  end

  def create
    client_params = params.require(:client).permit(:eni, :name, :email)
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path, notice: 'Cliente cadastrado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível registrar o cliente'
      render 'new'
    end
  end

  def review_deactivation
    @client = Client.find(params[:id])
  end

  def deactivate_cpf
    client = Client.find(params[:id])
    update_params = params.permit(:cancellation_reason)
    return unless client.update(update_params)

    client.inactive!
    redirect_to client_path(client.id), alert: 'Cliente bloqueado'
  end

  def activate_cpf
    client = Client.find(params[:id])
    return unless client.inactive?

    client.active!
    redirect_to client_path(client.id), notice: 'Cliente desbloqueado com sucesso'
  end
end
