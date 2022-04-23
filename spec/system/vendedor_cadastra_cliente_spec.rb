require 'rails_helper'

describe 'Vendedor cadastra um cliente' do
  it 'Com sucesso' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    fill_in 'CPF/CNPJ', with: '66899030012'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'Email', with: 'carlos@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Cliente cadastrado com sucesso'
  end

  it 'e todos os campos são obrigatórios' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    click_on 'Cadastrar'

    # Assert
    expect(page).not_to have_content 'Cliente cadastrado com sucesso'
    expect(page).to have_content 'Não foi possível registrar o cliente'
    expect(page).to have_content 'Verifique os campos abaixo:'
    expect(page).to have_content 'CPF/CNPJ não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Email não pode ficar em branco'
  end

  it 'e o eni deve ser único' do
    # Arrange
    user = create(:user)
    create(:client, eni: '66899030012')

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    fill_in 'CPF/CNPJ', with: '66899030012'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'Email', with: 'carlos@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Não foi possível registrar o cliente'
    expect(page).to have_content 'Verifique os campos abaixo:'
    expect(page).to have_content 'CPF/CNPJ já está em uso'
  end

  it 'e o eni é um cnpj' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    fill_in 'CPF/CNPJ', with: '94331487000139'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'Email', with: 'carlos@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Cliente cadastrado com sucesso'
  end

  it 'e o eni tem o formato inválido' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    fill_in 'CPF/CNPJ', with: '94331487000138'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'Email', with: 'carlos@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'CPF/CNPJ com formato inválido'
  end
end
