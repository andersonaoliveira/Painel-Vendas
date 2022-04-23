class OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[new index]
  before_action :authenticate_admin, only: %i[search]
  before_action :verify_ownership, only: %i[review_cancelation cancel_order]
  before_action :authenticate_status

  def new
    @client_id = params[:client_id]
    @order = Order.new
    @client = Client.find(@client_id)
    @api_produtos = api_check(Rails.configuration.apis['products_api'])
  end

  def create
    @order = Order.new(
      plan_id: params['client']['plan_id'],
      client_id: params['client']['client_id'],
      user_id: params['client']['user_id'],
      value: params['client']['value'],
      period: params['client']['period'],
      client_eni: params['client']['client_eni'],
      discount: params['client']['discount']
    )

    redirect_to order_path(@order.id), notice: 'Pedido cadastrado com sucesso!' if @order.save
  end

  def show
    @order = Order.find(params[:id])
    @client = Client.find(@order.client_id)
    @plan = Plan.find(@order.plan_id.to_s)
    @period = @order.period
    @price = @order.value
  end

  def index
    @users = User.where(role: 'salesperson')
    @orders = if current_user.salesperson?
                Order.where(user_id: current_user.id, status: :pending)
                     .or(Order.where(user_id: current_user.id, status: :concluded))
              else
                Order.where(status: :pending).or(Order.where(status: :concluded))
              end
  end

  def canceled
    @users = User.where(role: 'salesperson')
    @orders = if current_user.salesperson?
                Order.where(user_id: current_user.id, status: :canceled)
              else
                Order.where(status: :canceled)
              end
  end

  def review_cancelation
    @order = Order.find(params[:id])
    @client = Client.find(@order.client_id)
    @plan = Plan.find(@order.plan_id)
    @period = @order.period
    @price = @order.value
  end

  def cancel_order
    order = Order.find(params[:id])
    update_params = params.permit(:cancelation_reason)
    if update_params.values[0].empty?
      return redirect_to review_cancelation_order_path(order.id), alert: 'Motivo não pode ficar em branco'
    end

    api_domain = Rails.configuration.apis['clients_api']
    response = Faraday.patch("#{api_domain}/api/v1/cancelation/#{order.id}")

    case response.status
    when 200
      order.update(update_params)
      order.canceled!
      redirect_to canceled_orders_path, alert: 'Pedido Cancelado'
    when 406
      redirect_to review_cancelation_order_path(order.id), alert: 'O pedido já se encontra concluído'
    else
      redirect_to review_cancelation_order_path(order.id), alert: 'Não foi possível conectar com o sistema de clientes'
    end
  end

  def search
    if params[:query].present?
      id_user = User.find_by('name LIKE ?', "%#{params[:query]}%")
      id_client = Client.find_by('name LIKE ?', "%#{params[:query]}%")
      @orders = Order.where('user_id = ? or client_id = ?', id_user, id_client)
    else
      @orders = Order.all
    end
  end

  private

  def verify_ownership
    order = Order.find(params[:id])
    return if current_user == order.user || current_user.admin?

    redirect_to orders_path, alert: 'Acesso não permitido'
  end

  def api_check(path)
    Faraday.get(path)
    true
  rescue StandardError
    false
  end
end
