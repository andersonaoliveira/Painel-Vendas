require 'rails_helper'

describe 'Admin deve ser capaz de visualizar as comissoes dos vendedores' do
  it 'com sucesso' do
    # Arrange
    admin = create(:user)
    seller1 = create(:user, :salesperson, name: 'Jose', email: 'my_user1@locaweb.com.br')
    seller2 = create(:user, :salesperson, name: 'Maria', email: 'my_user2@locaweb.com.br')
    client1 = create(:client)
    create(:order, client: client1, user: seller1)
    commission1 = create(:commission, value: '42.42', user_id: seller1.id)
    commission1.created_at = '1990-09-19 00:00:00'
    commission1.save
    commission2 = create(:commission, value: '10.42', user_id: seller2.id)
    commission2.created_at = '1990-09-19 00:01:00'
    commission2.save

    # Act
    login_as(admin)
    visit root_path
    click_on 'Comissões'

    # Assert
    expect(page).to have_content 'Relação de vendedores'
    expect(page).to have_css 'li', text: 'Jose'
    expect(page).to have_css 'li', text: 'Maria'

    expect(page).to have_css 'h3', text: 'Comissões'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Jose'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'R$ 42,42'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Gerada em 1990-09-19 00:00:00 UTC'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Maria'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'R$ 10,42'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Gerada em 1990-09-19 00:01:00 UTC'
  end

  it 'com sucesso, mas não há nenhuma' do
    # Arrange
    admin = create(:user)
    create(:user, :salesperson, name: 'Jose', email: 'my_user1@locaweb.com.br')
    create(:user, :salesperson, name: 'Maria', email: 'my_user2@locaweb.com.br')

    # Act
    login_as(admin)
    visit root_path
    click_on 'Comissões'

    # Assert
    expect(page).to have_content 'Relação de vendedores'
    expect(page).to have_css 'li', text: 'Jose'
    expect(page).to have_css 'li', text: 'Maria'

    expect(page).to have_css 'h3', text: 'Comissões'
    expect(page).to have_css 'h3', text: 'Nenhuma comissão encontrada'
  end

  it 'e consegue ver todas de um vendedor especifico' do
    # Arrange
    admin = create(:user)
    seller1 = create(:user, :salesperson, name: 'Jose', email: 'my_user1@locaweb.com.br')
    seller2 = create(:user, :salesperson, name: 'Maria', email: 'my_user2@locaweb.com.br')
    client1 = create(:client)
    create(:order, client: client1, user: seller1)
    commission1 = create(:commission, value: '42.42', user_id: seller1.id)
    commission1.created_at = '1990-09-19 00:00:00'
    commission1.save
    commission2 = create(:commission, value: '12.50', user_id: seller1.id)
    commission2.created_at = '1990-09-19 00:00:00'
    commission2.save
    commission3 = create(:commission, value: '10.42', user_id: seller2.id)
    commission3.created_at = '1990-09-19 00:01:00'
    commission3.save

    # Act
    login_as(admin)
    visit root_path
    click_on 'Comissões'
    click_on 'Jose'

    # Assert
    expect(page).to have_css 'h3', text: 'Vendedor: Jose'
    expect(page).to have_css 'h3', text: 'Comissões'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Jose'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'R$ 42,42'
    expect(page).to have_css "tr#id#{commission1.id}", text: 'Gerada em 1990-09-19 00:00:00 UTC'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Jose'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'R$ 12,50'
    expect(page).to have_css "tr#id#{commission2.id}", text: 'Gerada em 1990-09-19 00:00:00 UTC'
    expect(page).not_to have_content 'Maria'
    expect(page).not_to have_content 'R$ 10,42'
    expect(page).not_to have_content 'Gerada em 1990-09-19 00:01:00 UTC'
  end
end
