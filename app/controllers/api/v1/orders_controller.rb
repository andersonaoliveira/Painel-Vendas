class Api::V1::OrdersController < Api::V1::ApiController
  def show
    order = Order.find_by(params[:id])
    if order
      render json: order.as_json(except: %i[created_at updated_at cancelation_reason]), status: 200
    else
      render json: '{"error": "Objeto não encontrado"}', status: 404
    end
  end

  def create
    order_params = params.permit(:plan_id, :period, :value, :client_eni)
    order = Order.new(order_params)
    client = Client.find_by(eni: order.client_eni)
    order.client_id = client.id unless client.nil? || client.inactive?

    if order.save
      render json: order.as_json, status: 201
    elsif client.nil?
      render status: 422, json: '{"error": "Cliente não encontrado no sistema"}'
    elsif client.inactive?
      render status: 422, json: '{"error": "CPF do cliente está inativo no sistema"}'
    else
      render status: 422, json: order.errors.full_messages
    end
  end

  def clients
    client = Client.find_by(eni: params[:id])
    return return404 if client.nil?

    client_orders = client.orders
    if client_orders.empty?
      render json: '{"alert": "Nenhum pedido registrado"}', status: 200
    else
      render json: client_orders.as_json(except: %i[created_at updated_at cancelation_reason]), status: 200
    end
  end

  def concluded
    order = Order.find(params[:order_id])
    return render json: '{"alert": "Pedido já foi cancelado"}', status: 200 if order.canceled?

    order.concluded!
    Commission.generate(order)
    render json: order.as_json(except: %i[created_at updated_at cancelation_reason]), status: 200
  end

  def pending
    order = Order.find(params[:order_id])
    return render json: '{"alert": "Pedido já foi cancelado"}', status: 200 if order.canceled?

    order.pending!
    Commission.clear(order)
    render json: order.as_json(except: %i[created_at updated_at cancelation_reason]), status: 200
  end

  def canceled
    order = Order.find(params[:order_id])
    return render json: '{"alert": "Pedido não pode ser cancelado"}', status: 200 unless order.pending?

    order.canceled!
    order.update(cancelation_reason: 'Pedido cancelado pelo sistema de clientes') if order.canceled?
    Commission.clear(order)
    render json: order.as_json(except: %i[created_at updated_at]), status: 200
  end
end
