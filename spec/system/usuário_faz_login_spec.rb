require 'rails_helper'

describe 'Administrador visualiza tela de login' do
  it 'com sucesso' do
    # Arrange
    create(:user)
    # Act
    visit root_path

    # Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_css 'h2', text: 'Log in'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_content 'Log in'
  end

  it 'e faz login com sucesso' do
    # Arrange
    create(:user, email: 'admin@locaweb.com.br')

    # Act
    visit root_path
    fill_in 'E-mail', with: 'admin@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Log in'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Olá, Alan'
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_link 'Sair', href: destroy_user_session_path
    expect(page).not_to have_link 'Entrar', href: new_user_session_path
    expect(page).not_to have_content 'Turing'
  end

  it 'e administrador ainda não está cadastrado no sistema' do
    # Arrange

    # Act
    visit root_path
    click_on 'Inscrever-se'

    # Assert
    expect(page).to have_content 'Entre em contato com o departamento de TI para realizar seu cadastro'
  end
end
