class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :return404
  rescue_from ActiveRecord::ConnectionNotEstablished, with: :return500

  def return404
    render status: 404, json: { error: 'Objeto não encontrado' }
  end

  def return500
    render status: 500, json: { error: 'Não foi possível conectar ao banco de dados' }
  end
end
