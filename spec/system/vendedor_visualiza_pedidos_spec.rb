require 'rails_helper'

describe 'Vendedor visualiza pedidos' do
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
    user = create(:user, role: :salesperson)
    client = create(:client)
    client2 = create(:client, name: 'Carlos', eni: '33333333333')
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: user.id,
                   client_id: client.id, value: price.value)
    create(:order, status: :canceled, plan_id: plan.id, period: price.period, user_id: user.id,
                   client_id: client2.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_css 'td', text: '1'
    expect(page).to have_css 'td', text: 'Alan Turing'
    expect(page).to have_css 'td', text: 'Carl Sagan', count: 1
    expect(page).to have_css 'td', text: 'Pendente'
    expect(page).not_to have_css 'td', text: '2'
    expect(page).not_to have_css 'td', text: 'Carlos'
    expect(page).not_to have_css 'td', text: 'Cancelado'
  end

  it 'e vê os pedidos cancelados' do
    # Arrange
    user = create(:user, role: :salesperson)
    client = create(:client)
    client2 = create(:client, name: 'Carlos', eni: '33333333333')

    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: user.id,
                   client_id: client.id, value: price.value)
    create(:order, status: :canceled, plan_id: plan.id, period: price.period, user_id: user.id,
                   client_id: client2.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on 'Pedidos cancelados'

    expect(page).not_to have_css 'td', text: '1'
    expect(page).not_to have_css 'td', text: 'Carl Sagan'
    expect(page).not_to have_css 'td', text: 'Pendente'
    expect(page).to have_css 'td', text: '2'
    expect(page).to have_css 'td', text: 'Alan Turing', count: 1
    expect(page).to have_css 'td', text: 'Carlos'
    expect(page).to have_css 'td', text: 'Cancelado'
  end

  it 'e não vê pedidos de outros vendedores' do
    user = create(:user, role: :salesperson)
    another_salesperson = create(:user, name: 'Neil DeGrasse Tyson', email: 'neil@locaweb.com.br',
                                        role: :salesperson)

    client = create(:client)
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: user.id, client_id: client.id,
                   value: price.value)
    second_order = create(:order, plan_id: plan.id, period: price.period,
                                  user_id: another_salesperson.id, client_id: client.id,
                                  value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_css 'td', text: '1'
    expect(page).to have_css 'td', text: 'Alan Turing'
    expect(page).to have_css 'td', text: 'Carl Sagan'
    expect(page).to have_css 'td', text: 'Pendente'
    expect(page).not_to have_content 'Neil DeGrasse Tyson'
    expect(page).not_to have_content second_order.id
  end

  it 'e não existem pedidos cadastrados' do
    # Arrange
    user = create(:user, role: :salesperson)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_css 'h2', text: 'Nenhum pedido'
  end

  it 'e clica para ver detalhes dos pedidos' do
    user = create(:user, role: :salesperson)
    client = create(:client)
    plan = Plan.new(id: 1, name: 'Plano X', product_group: { name: 'Hospedagem' })
    price = Price.new(id: 1, period: 'Mensal', value: '50')

    allow(Plan).to receive(:find).and_return(plan)
    allow(Price).to receive(:find_by).with(plan.id, price.period).and_return(price)

    create(:order, plan_id: plan.id, period: price.period, user_id: user.id,
                   client_id: client.id, value: price.value)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    click_on '1'

    # Assert
    expect(page).to have_css 'div', text: 'Carl Sagan'
    expect(page).to have_css 'div', text: '49773455092'
    expect(page).to have_css 'div', text: 'Plano X'
    expect(page).to have_css 'div', text: 'Mensal'
    expect(page).to have_css 'div', text: 'R$ 50,00'
    expect(page).to have_css 'div', text: 'Pendente'
  end
end
