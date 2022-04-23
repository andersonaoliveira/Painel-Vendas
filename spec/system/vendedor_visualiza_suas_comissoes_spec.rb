require 'rails_helper'

describe 'Vendedor deve ser capaz de visualizar sua propria comissoes' do
  it 'mas usuário não logado não tem acesso ao link' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content 'Minhas Comissões'
    expect(page).not_to have_content 'Comissões'
  end

  it 'mas usuário não logado não acessa a url diretamente' do
    # Arrange

    # Act
    visit commissions_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = create(:user, :salesperson)
    client1 = create(:client)
    create(:order, client: client1, user: user)
    commission1 = create(:commission, value: '42.42', user_id: user.id)
    commission1.created_at = '1990-09-19 00:00:00'
    commission1.save
    commission2 = create(:commission, value: '10.42', user_id: user.id)
    commission2.created_at = '1990-09-19 00:01:00'
    commission2.save

    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Comissões'

    # Assert
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Alan Turing'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'R$ 42,42'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Gerada em 1990-09-19 00:00:00 UTC'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Alan Turing'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'R$ 10,42'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Gerada em 1990-09-19 00:01:00 UTC'
  end

  it 'com sucesso, mas não há nenhuma' do
    # Arrange
    user = create(:user, :salesperson)
    client1 = create(:client)
    create(:order, client: client1, user: user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Comissões'

    # Assert
    expect(page).to have_css 'h3', text: 'Nenhuma comissão encontrada'
  end

  it 'apenas as suas, não as de outros vendedores' do
    # Arrange
    user1 = create(:user, :salesperson)
    user2 = create(:user, :salesperson, name: 'Bruno Carvalho', email: 'brunoc@locaweb.com.br')
    client1 = create(:client)
    create(:order, client: client1, user: user1)
    commission1 = create(:commission, value: '42.42', user_id: user1.id)
    commission1.created_at = '1990-09-19 00:00:00'
    commission1.save
    commission2 = create(:commission, value: '10.42', user_id: user1.id)
    commission2.created_at = '1990-09-19 00:01:00'
    commission2.save
    commission3 = create(:commission, value: '8.50', user_id: user2.id)
    commission3.save

    # Act
    login_as(user1)
    visit root_path
    click_on 'Minhas Comissões'

    # Assert
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Alan Turing'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'R$ 42,42'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Gerada em 1990-09-19 00:00:00 UTC'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Alan Turing'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'R$ 10,42'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Gerada em 1990-09-19 00:01:00 UTC'
    expect(page).not_to have_content 'Relação de vendedores'
    expect(page).not_to have_content 'Bruno Carvalho'
    expect(page).not_to have_content 'R$ 8,50'
  end

  it 'apenas as suas, não as de outros vendedores, nem diretamente pelo link' do
    # Arrange
    user1 = create(:user, :salesperson)
    user2 = create(:user, :salesperson, name: 'Bruno Carvalho', email: 'brunoc@locaweb.com.br')
    client1 = create(:client)
    create(:order, client: client1, user: user1)
    commission1 = create(:commission, value: '42.42', user_id: user1.id)
    commission1.created_at = '1990-09-19 00:00:00'
    commission1.save
    commission2 = create(:commission, value: '10.42', user_id: user1.id)
    commission2.created_at = '1990-09-19 00:01:00'
    commission2.save
    commission3 = create(:commission, value: '8.50', user_id: user2.id)
    commission3.save

    # Act
    login_as(user1)
    visit commissions_seller_path(user2)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Necessita privilégios de administrador'
  end
end
