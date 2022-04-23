require 'rails_helper'

describe 'Administrador cadastra vendedor' do
  context 'com sucesso' do
    it 'ativo' do
      # Arrange
      user = create(:user, role: :admin)
      # Act
      login_as(user)
      visit root_path
      click_on 'Vendedores'
      click_on 'Cadastrar um vendedor'
      fill_in 'E-mail', with: 'carlos@locaweb.com.br'
      fill_in 'Nome', with: 'Carlos'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirme sua senha', with: '12345678'
      choose(option: 'active')
      click_on 'Cadastrar'
      # Assert
      expect(page).to have_content 'Vendedor cadastrado com sucesso'
      expect(page).to have_content 'Carlos'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'carlos@locaweb.com.br'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Ativo'
    end

    it 'inativo' do
      # Arrange
      user = create(:user, role: :admin)

      # Act
      login_as(user)
      visit root_path
      click_on 'Vendedores'
      click_on 'Cadastrar um vendedor'
      fill_in 'E-mail', with: 'carlos@locaweb.com.br'
      fill_in 'Nome', with: 'Carlos'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirme sua senha', with: '12345678'
      choose(option: 'inactive')
      click_on 'Cadastrar'

      # Assert
      expect(page).to have_content 'Vendedor cadastrado com sucesso'
      expect(page).to have_content 'Carlos'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'carlos@locaweb.com.br'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Inativo'
    end
  end
  context 'e falhou' do
    it 'pois os campos estão em branco' do
      # Arrange
      user = create(:user, role: :admin)

      # Act
      login_as(user)
      visit root_path
      click_on 'Vendedores'
      click_on 'Cadastrar um vendedor'
      click_on 'Cadastrar'

      # Assert
      expect(page).to have_content 'Verifique os campos abaixo'
      expect(page).to have_content 'Não foi possível registrar o vendedor'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(page).to have_content 'Senha não pode ficar em branco'
    end

    it 'pois não é administrador' do
      # Arrange
      user = create(:user, role: :salesperson)

      # Act
      login_as(user)
      visit root_path

      # Assert
      expect(page).not_to have_link 'Cadastrar um vendedor'
    end

    it 'pois não é administrador e tentou acessar pela URL' do
      # Arrange
      user = create(:user, role: :salesperson)

      # Act
      login_as(user)
      visit new_seller_path

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Necessita privilégios de administrador'
    end

    it 'pois não está logado e tentou acessar pela URL' do
      # Arrange

      # Act
      visit new_seller_path

      # Assert
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end
  end
end
