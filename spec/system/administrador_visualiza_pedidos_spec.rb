require 'rails_helper'

describe 'Administrador visualiza pedidos' do
  it 'mas não está logado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Pedidos'
  end

  it 'e não consegue acessar a página de pedidos sem estar logado' do
    # Arrange

    # Act
    visit orders_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = create(:user)
    client = create(:client)
    seller = create(:user, name: 'Dwight Schrute', role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    ProductGroup.new(id: 1, name: 'Hospedagem')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: seller.id,
                   client_id: client.id, value: price.value)
    create(:order, status: :canceled, plan_id: plan.id, period: price.period, user_id: seller.id,
                   client_id: client.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_css 'td', text: '1'
    expect(page).to have_css 'td', text: 'Dwight Schrute', count: 1
    expect(page).to have_css 'td', text: 'Carl Sagan', count: 1
    expect(page).to have_css 'td', text: 'Pendente'
    expect(page).not_to have_css 'td', text: '2'
    expect(page).not_to have_css 'td', text: 'Cancelado'
  end

  it 'e vê pedidos cancelados' do
    # Arrange
    user = create(:user)
    client = create(:client)
    seller = create(:user, name: 'Dwight Schrute', role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: seller.id,
                   client_id: client.id, value: price.value)
    create(:order, status: :canceled, plan_id: plan.id, period: price.period, user_id: seller.id,
                   client_id: client.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on 'Pedidos cancelados'

    # Assert
    expect(page).not_to have_css 'td', text: '1'
    expect(page).to have_css 'td', text: 'Dwight Schrute', count: 1
    expect(page).to have_css 'td', text: 'Carl Sagan', count: 1
    expect(page).not_to have_css 'td', text: 'Pendente'
    expect(page).to have_css 'td', text: '2'
    expect(page).to have_css 'td', text: 'Cancelado'
  end

  it 'e não existem pedidos cadastrados' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_css 'h2', text: 'Nenhum pedido'
  end

  it 'e clica para ver detalhes dos pedidos' do
    user = create(:user)
    client = create(:client)
    seller = create(:user, role: :salesperson, email: 'dwightschrute@locaweb.com.br')
    ProductGroup.new(id: 1, name: 'Hospedagem')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
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

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'Plano X'
    expect(page).to have_content 'Mensal'
    expect(page).to have_content 'R$ 50,00'
  end
end
