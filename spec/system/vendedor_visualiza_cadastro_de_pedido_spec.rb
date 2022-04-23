require 'rails_helper'

def api_check(path)
  Faraday.get(path)
  true
rescue StandardError
  false
end

describe 'Vendedor visualiza tela de cadastro de pedido' do
  api_produtos = api_check(Rails.configuration.apis['products_api'])

  it 'mas usuário não logado não tem acesso ao link' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Clientes'
  end

  it 'mas usuário não logado não acessa a url diretamente' do
    # Arrange
    client = create(:client)

    # Act
    visit new_client_order_path(client.id)
    # Assert
    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_css 'h1', text: 'Cadastro de novo pedido'
  end

  it 'com sucesso', if: api_produtos do
    # Arrange
    user = create(:user)
    client = create(:client)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    within "tr#client-#{client.id}" do
      click_on 'Fazer pedido'
    end

    # Assert
    expect(page).to have_css 'h1', text: 'Cadastro de novo pedido'
    expect(page).to have_field 'Plano'
    expect(page).to have_button 'Salvar'
  end
end
