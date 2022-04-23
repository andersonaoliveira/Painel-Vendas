require 'rails_helper'

describe 'Usuário busca pedidos' do
  it 'e faz uma busca vazia' do
    # Arrange
    user = create(:user)
    salesperson_a = User.create(name: 'Linus Torvalds', email: 'vendedor1@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)
    salesperson_b = User.create(name: 'Yukihiro Matsumoto', email: 'vendedor2@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)

    client_a = Client.create(eni: '92817341090', name: 'Ada Lovelace', email: 'ada@email.com')
    client_b = Client.create(eni: '45994858021', name: 'Margaret Hamilton', email: 'margaret@email.com')

    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_a.id,
                  user_id: salesperson_a.id, value: '50', client_eni: client_a.eni)
    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_b.id,
                  user_id: salesperson_b.id, value: '50', client_eni: client_b.id)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    fill_in :query, with: ''
    click_on 'Buscar'

    # Assert
    expect(current_path).to eq search_orders_path
    expect(page).to have_css 'td', text: 'Linus Torvalds'
    expect(page).to have_css 'td', text: 'Ada Lovelace'
    expect(page).to have_css 'td', text: 'Yukihiro Matsumoto'
    expect(page).to have_css 'td', text: 'Margaret Hamilton'
  end

  it 'e busca por um vendedor' do
    # Arrange
    user = create(:user)
    salesperson_a = User.create(name: 'Linus Torvalds', email: 'vendedor1@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)
    salesperson_b = User.create(name: 'Yukihiro Matsumoto', email: 'vendedor2@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)

    client_a = Client.create(eni: '92817341090', name: 'Ada Lovelace', email: 'ada@email.com')
    client_b = Client.create(eni: '45994858021', name: 'Margaret Hamilton', email: 'margaret@email.com')

    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_a.id,
                  user_id: salesperson_a.id, value: '50', client_eni: client_a.eni)
    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_b.id,
                  user_id: salesperson_b.id, value: '50', client_eni: client_b.id)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    fill_in :query, with: 'Linus'
    click_on 'Buscar'

    # Assert
    expect(current_path).to eq search_orders_path
    expect(page).to have_css 'td', text: 'Linus Torvalds'
    expect(page).to have_css 'td', text: 'Ada Lovelace'
    expect(page).not_to have_css 'td', text: 'Yukihiro Matsumoto'
    expect(page).not_to have_css 'td', text: 'Margaret Hamilton'
  end

  it 'e busca por um cliente' do
    # Arrange
    user = create(:user)
    salesperson_a = User.create(name: 'Linus Torvalds', email: 'vendedor1@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)
    salesperson_b = User.create(name: 'Yukihiro Matsumoto', email: 'vendedor2@locaweb.com.br', password: '12345678',
                                role: :salesperson, status: :active)

    client_a = Client.create(eni: '92817341090', name: 'Ada Lovelace', email: 'ada@email.com')
    client_b = Client.create(eni: '45994858021', name: 'Margaret Hamilton', email: 'margaret@email.com')

    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_a.id,
                  user_id: salesperson_a.id, value: '50', client_eni: client_a.eni)
    Order.create!(status: :pending, plan_id: 1, period: 'Mensal', client_id: client_b.id,
                  user_id: salesperson_b.id, value: '50', client_eni: client_b.id)

    # Act
    login_as(user)
    visit root_path
    click_on 'Pedidos'
    fill_in :query, with: 'Margaret'
    click_on 'Buscar'

    # Assert
    expect(current_path).to eq search_orders_path
    expect(page).to have_css 'td', text: 'Yukihiro Matsumoto'
    expect(page).to have_css 'td', text: 'Margaret Hamilton'
    expect(page).not_to have_css 'td', text: 'Linus Torvalds'
    expect(page).not_to have_css 'td', text: 'Ada Lovelace'
  end
end
