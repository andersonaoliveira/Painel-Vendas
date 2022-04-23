require 'rails_helper'

describe 'Uma confirmação de pagamento vinda da API deve gerar uma comissão' do
  it 'com sucesso' do
    # Arrange
    client = create(:client)
    user = create(:user)
    order1 = create(:order, :pending, client: client, user: user, value: 100.00)
    # Act
    headers = { 'CONTENT_TYPE' => 'application/json' }
    patch "/api/v1/orders/#{order1.id}/concluded", headers: headers

    # Assert
    commission = Commission.find_by(order_id: order1.id)
    expect(commission.value).to eq 1
  end

  it 'com sucesso, atualizando-a caso o preço do pedido seja atualizado' do
    # Arrange
    client = create(:client)
    user = create(:user)
    order1 = create(:order, :pending, client: client, user: user, value: 100.00)
    # Act
    headers = { 'CONTENT_TYPE' => 'application/json' }
    patch "/api/v1/orders/#{order1.id}/concluded", headers: headers
    order1.update(value: 90.00)
    patch "/api/v1/orders/#{order1.id}/concluded", headers: headers

    # Assert
    commission = Commission.find_by(order_id: order1.id)
    expect(commission.value).to eq 0.9
  end

  it 'e o estorno zera a comissao' do
    # Arrange
    client = create(:client)
    user = create(:user)
    order1 = create(:order, :concluded, client: client, user: user, value: 100)
    create(:commission, value: 1)

    # Act
    headers = { 'CONTENT_TYPE' => 'application/json' }
    patch "/api/v1/orders/#{order1.id}/pending", headers: headers

    # Assert
    commission = Commission.find_by(order_id: order1.id)
    expect(commission.value).to eq 0
  end

  it 'mas o id de produto não existe (patch de concluded)' do
    # Arrange
    create(:client)
    create(:user)
    # Act
    headers = { 'CONTENT_TYPE' => 'application/json' }
    patch '/api/v1/orders/99999999999/concluded', headers: headers

    # Assert
    commission = Commission.find_by(order_id: 99_999_999_999)
    expect(commission.nil?).to eq true
  end

  it 'mas o id de produto não existe (patch de pending)' do
    # Arrange
    create(:client)
    create(:user)
    # Act
    headers = { 'CONTENT_TYPE' => 'application/json' }
    patch '/api/v1/orders/99999999999/pending', headers: headers

    # Assert
    commission = Commission.find_by(order_id: 99_999_999_999)
    expect(commission.nil?).to eq true
  end

  it 'exceto no caso de renovação pois não há vendedor' do
    # Arrange
    create(:client)

    # Act
    number_of_commissions = Commission.count
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/orders', params: '{ "plan_id": "1",
                                      "period": "Mensal",
                                      "value": "50",
                                      "client_eni": "49773455092"
                                    }',
                           headers: headers

    patch "/api/v1/orders/#{Order.last.id}/concluded", headers: headers

    # Assert
    expect(Commission.count).to eq number_of_commissions
  end
end
