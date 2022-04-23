require 'rails_helper'

describe 'Vendedor navega pelo sistema' do
  context 'tela de clientes' do
    it 'status ativo' do
      # Assert
      seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :active)
      create(:client, eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com')
      create(:client, eni: '66899030012', name: 'Carlos', email: 'carlos@email.com')

      # Act
      login_as(seller)
      visit clients_path

      # Arrange
      expect(page).to have_content 'CarlosEnterprises'
      expect(page).to have_content 'Carlos'
    end

    it 'status inativo' do
      # Assert
      seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :inactive)
      create(:client, eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com')
      create(:client, eni: '66899030012', name: 'Carlos', email: 'carlos@email.com')

      # Act
      login_as(seller)
      visit clients_path

      # Arrange
      expect(current_path).to eq root_path
      expect(page).not_to have_content 'CarlosEnterprises'
      expect(page).not_to have_content 'Carlos'
      expect(page).to have_content 'Vendedor com status inativo, contate um administrador'
    end

    it 'e não consegue ver o botão de bloqueio de clientes' do
      # Assert
      seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :active)
      client = create(:client, eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com')

      # Act
      login_as(seller)
      visit client_path(client.id)

      # Arrange
      expect(page).to have_content 'CarlosEnterprises'
      expect(page).to have_content '32586458000160'
      expect(page).to have_content 'CPF ativo'
      expect(page).not_to have_button 'Inativar CPF'
    end

    it 'e não consegue ver o botão de desbloqueio de clientes' do
      # Assert
      seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :active)
      client = create(:client, eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com',
                               eni_status: :inactive)

      # Act
      login_as(seller)
      visit client_path(client.id)

      # Arrange
      expect(page).to have_content 'CarlosEnterprises'
      expect(page).to have_content '32586458000160'
      expect(page).to have_content 'CPF inativo'
      expect(page).not_to have_button 'Reativar CPF'
    end

    it 'e não consegue acessar a rota de confirmação de desativação' do
      # Assert
      seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :active)
      client = create(:client)

      # Act
      login_as(seller)
      visit review_deactivation_client_path(client.id)

      # Arrange
      expect(current_path).to eq root_path
      expect(page).to have_content 'Necessita privilégios de administrador'
    end
  end
end
