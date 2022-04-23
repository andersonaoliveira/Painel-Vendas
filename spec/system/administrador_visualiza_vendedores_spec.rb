require 'rails_helper'

describe 'Administrador visualiza todos os vendedores' do
  it 'mas usuário não logado não vê a tela' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Vendedores'
  end

  it 'mas usuário não consegue acessar o link diretamente' do
    # Arrange

    # Act
    visit sellers_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = create(:user)
    create(:user, name: 'John', email: 'john@locaweb.com.br', role: :salesperson)
    create(:user, name: 'Wayne', email: 'wayne@locaweb.com.br', role: :salesperson, status: :inactive)

    # Act
    login_as(user)
    visit root_path
    click_on 'Vendedores'

    # Assert
    within('table#active-sellers') do
      expect(page).to have_css 'td', text: 'John'
      expect(page).to have_css 'td', text: 'john@locaweb.com.br'
      expect(page).to have_css 'td', text: 'Ativo'
    end

    within('table#inactive-sellers') do
      expect(page).to have_css 'td', text: 'Wayne'
      expect(page).to have_css 'td', text: 'wayne@locaweb.com.br'
      expect(page).to have_css 'td', text: 'Inativo'
    end
  end

  it 'mas vendedor não vê outros vendedores' do
    # Arrange
    seller = create(:user, role: :salesperson)

    # Act
    login_as(seller)
    visit root_path

    # Assert
    expect(page).not_to have_link 'Vendedores'
  end

  it 'mas vendedor não acessa link diretamente' do
    # Arrange
    seller = create(:user, role: :salesperson)

    # Act
    login_as(seller)
    visit sellers_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Necessita privilégios de administrador'
  end

  it 'mas não existem vendedores no sistema' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Vendedores'

    # Assert
    expect(page).to have_css 'h2', text: 'Nenhum vendedor cadastrado'
  end
end
