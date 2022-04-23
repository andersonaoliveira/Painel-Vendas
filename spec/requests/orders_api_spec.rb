require 'rails_helper'

describe 'API de Pedidos' do
  context 'GET /api/v1/orders/clients/:eni' do
    it 'com sucesso' do
      # Arrange
      client = create(:client)
      user = create(:user)
      create(:order, client: client, user: user)
      create(:order, plan_id: 2, client: client, user: user)

      # Act
      get "/api/v1/orders/clients/#{client.eni}"

      # Assert
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_response[0]['status']).to eq 'pending'
      expect(parsed_response[0]['plan_id']).to eq 1
      expect(parsed_response[0]['value']).to eq 30.0.to_s
      expect(parsed_response[0]['period']).to eq 'Mensal'

      expect(parsed_response[1]['status']).to eq 'pending'
      expect(parsed_response[1]['plan_id']).to eq 2
      expect(parsed_response[1]['value']).to eq 30.0.to_s
      expect(parsed_response[1]['period']).to eq 'Mensal'

      expect(response.body).not_to include 'cancelation_reason'
    end

    it 'cliente não existe' do
      # Arrange

      # Act
      get '/api/v1/orders/clients/999999999999'

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['error']).to eq 'Objeto não encontrado'
    end

    it 'cliente não possui pedidos' do
      # Arrange
      client = create(:client)

      # Act
      get "/api/v1/orders/clients/#{client.eni}"

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['alert']).to eq 'Nenhum pedido registrado'
    end
  end

  context 'GET /api/vi/orders/:id' do
    it 'com sucesso' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :pending, client: client, user: user)

      # Act
      get "/api/v1/orders/#{order1.id}"

      # Assert
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['status']).to eq 'pending'
      expect(parsed_response['plan_id']).to eq 1
      expect(parsed_response['value']).to eq 30.0.to_s
      expect(parsed_response['period']).to eq 'Mensal'
    end

    it 'pedido não existe' do
      # Arrange

      # Act
      get '/api/v1/orders/999999'

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['error']).to eq 'Objeto não encontrado'
    end

    it 'e banco de dados está indisponível' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order = create(:order, client: client, user: user)

      allow(Order).to receive(:find_by).with(order.id.to_s).and_raise ActiveRecord::ConnectionNotEstablished

      # Act
      get "/api/v1/orders/#{order.id}"
      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq 'Não foi possível conectar ao banco de dados'
    end
  end

  context 'PATCH /api/v1/orders/:id/concluded' do
    it 'com sucesso' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :pending, client: client, user: user)
      create(:order, :concluded, plan_id: 2, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/concluded", headers: headers

      # Assert
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['status']).to eq 'concluded'
      expect(parsed_response['plan_id']).to eq 1
      expect(parsed_response['value']).to eq 30.0.to_s
      expect(parsed_response['period']).to eq 'Mensal'
    end

    it 'pedido não existe' do
      # Arrange

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch '/api/v1/orders/999999/concluded', headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['error']).to eq 'Objeto não encontrado'
    end

    it 'muda o status de um pedido cancelado' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :canceled, client: client, user: user)
      create(:order, :concluded, plan_id: 2, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/concluded", headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['alert']).to eq 'Pedido já foi cancelado'
    end
  end

  context 'PATCH /api/v1/orders/:id/pending' do
    it 'com sucesso' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :concluded, client: client, user: user)
      create(:order, :concluded, plan_id: 2, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/pending", headers: headers

      # Assert
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['status']).to eq 'pending'
      expect(parsed_response['plan_id']).to eq 1
      expect(parsed_response['value']).to eq 30.0.to_s
      expect(parsed_response['period']).to eq 'Mensal'
    end

    it 'pedido não existe' do
      # Arrange

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch '/api/v1/orders/999999/pending', headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['error']).to eq 'Objeto não encontrado'
    end

    it 'muda o status de um pedido cancelado' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :canceled, client: client, user: user)
      create(:order, :concluded, plan_id: 2, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/pending", headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['alert']).to eq 'Pedido já foi cancelado'
    end
  end

  context 'PATCH /api/v1/orders/:id/canceled' do
    it 'com sucesso' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :pending, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/canceled", headers: headers

      # Assert
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['status']).to eq 'canceled'
      expect(parsed_response['plan_id']).to eq 1
      expect(parsed_response['value']).to eq 30.0.to_s
      expect(parsed_response['period']).to eq 'Mensal'
      expect(parsed_response['cancelation_reason']).to eq 'Pedido cancelado pelo sistema de clientes'
    end

    it 'pedido não existe' do
      # Arrange

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch '/api/v1/orders/999999/canceled', headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['error']).to eq 'Objeto não encontrado'
    end

    it 'muda o status de um pedido cancelado' do
      # Arrange
      client = create(:client)
      user = create(:user)
      order1 = create(:order, :canceled, client: client, user: user)
      create(:order, :concluded, plan_id: 2, client: client, user: user)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/orders/#{order1.id}/canceled", headers: headers

      # Assert
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_response['alert']).to eq 'Pedido não pode ser cancelado'
    end
  end

  context 'POST /api/v1/orders/' do
    it 'com sucesso' do
      # Arrange
      create(:client)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/orders', params: '{ "plan_id": "1",
                                        "period": "Mensal",
                                        "value": "50",
                                        "client_eni": "49773455092"
                                      }',
                             headers: headers

      # Assert
      expect(response.status).to eq 201
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['plan_id']).to be_a_kind_of(Integer)
      expect(parsed_response['period']).to eq 'Mensal'
      expect(parsed_response['value']).to eq '50.0'
      expect(parsed_response['client_eni']).to eq '49773455092'
    end

    it 'e cliente não existe no sistema' do
      # Arrange

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/orders', params: '{ "plan_id": "1",
                                        "period": "Mensal",
                                        "value": "50",
                                        "client_eni": "36645204086"
                                      }',
                             headers: headers

      # Assert
      expect(response.status).to eq 422
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq 'Cliente não encontrado no sistema'
    end

    it 'e CPF do cliente está cancelado no sistema' do
      # Arrange
      create(:client, eni_status: 'inactive')

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/orders', params: '{ "plan_id": "1",
                                        "value": "50",
                                        "client_eni": "49773455092"
                                      }',
                             headers: headers

      # Assert
      expect(response.status).to eq 422
      expect(response.body).to include 'CPF do cliente está inativo no sistema'
    end

    it 'e nem todos os dados foram incluídos' do
      # Arrange
      create(:client)

      # Act
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/orders', params: '{ "plan_id": "1",
                                        "value": "50",
                                        "client_eni": "49773455092"
                                      }',
                             headers: headers

      # Assert
      expect(response.status).to eq 422
      expect(response.body).to include 'Periodicidade não pode ficar em branco'
    end
  end
end
