require 'rails_helper'

describe 'Usuário busca cliente pelo CPF' do
  it 'mas visitante não vê o link na tela principal' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Clientes'
  end

  it 'mas visitante não consegue realizar a busca digitando a url' do
    # Arrange

    # Act
    visit clients_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = create(:user)
    create(:client)
    Client.create!(name: 'Ada Lovelace', eni: '28792134017', email: 'ada@lovelace.com')

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    fill_in 'CPF do cliente', with: '49773455092'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'carl@sagan.com'
    expect(page).to have_content '49773455092'
    expect(page).to have_content 'CPF ativo'
  end

  it 'mas cliente ainda não está cadastrado no sistema' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    fill_in 'CPF do cliente', with: '49773455092'
    click_on 'Buscar'

    # Assert
    expect(current_path).to eq clients_path
    expect(page).to have_content 'Nenhum cliente'
  end
end
