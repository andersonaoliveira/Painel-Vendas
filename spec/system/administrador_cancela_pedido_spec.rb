require 'rails_helper'

api_domain = Rails.configuration.apis['clients_api']

describe 'Administrador acessa tela de pedido' do
  it 'e vê a tela de cancelamento' do
    # Arrange
    user = create(:user)
    client = create(:client)
    seller = create(:user, role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: 'Hospedagem')
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: seller.id,
                   client_id: client.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on '1'
    click_on 'Cancelar pedido'

    # Assert
    expect(page).to have_content 'Confirmar cancelamento de pedido'
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content '49773455092'
    expect(page).to have_content 'Plano X'
    expect(page).to have_content 'Mensal'
    expect(page).to have_content 'R$ 50,00'
    expect(page).to have_content 'Tem certeza que deseja cancelar esse pedido?'
    expect(page).to have_content 'Motivo:'
    expect(page).to have_button 'Cancelar'
  end

  it 'e cancela pedido' do
    # Arrange
    user = create(:user)
    client = create(:client)
    seller = create(:user, name: 'Dwight Schrute', role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: 'Hospedagem')
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    order = create(:order, plan_id: plan.id, period: price.period, user_id: seller.id,
                           client_id: client.id, value: price.value)

    response = Faraday::Response.new(status: 200, response_body: order)
    allow(Faraday).to receive(:patch).with("#{api_domain}/api/v1/cancelation/#{order.id}").and_return(response)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on '1'
    click_on 'Cancelar pedido'
    fill_in 'Motivo', with: 'falta de pgto'
    click_on 'Cancelar'

    # Assert
    expect(current_path).to eq canceled_orders_path
    expect(page).to have_content '1'
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'Dwight Schrute'
    expect(page).to have_content 'Cancelado'
  end

  it 'e não preencheu o motivo' do
    # Arrange
    user = create(:user)
    client = create(:client)
    seller = create(:user, name: 'Dwight Schrute', role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: 'Hospedagem')
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    order = create(:order, plan_id: plan.id, period: price.period, user_id: seller.id,
                           client_id: client.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on '1'
    click_on 'Cancelar pedido'
    click_on 'Cancelar'

    # Assert
    expect(current_path).to eq review_cancelation_order_path(order.id)
    expect(page).to have_content 'Motivo não pode ficar em branco'
  end
end
