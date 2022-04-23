require 'rails_helper'

describe 'Administrador acessa página do cliente' do
  it 'e vê página de bloqueio de cpf' do
    # Arrange
    admin = create(:user)
    client = create(:client, eni: '28496429083')

    # Act
    login_as(admin)
    visit clients_path
    within("tr#client-#{client.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Inativar CPF'

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'carl@sagan.com'
    expect(page).to have_content '28496429083'
    expect(page).to have_content 'Tem certeza que deseja Bloquear este cliente?'
    expect(page).to have_button 'Confirmar'
    expect(page).to have_button 'Voltar'
  end

  it 'e bloqueia cpf do cliente' do
    # Arrange
    admin = create(:user)
    client = create(:client, eni: '28496429083')

    # Act
    login_as(admin)
    visit client_path(client.id)
    click_on 'Inativar CPF'
    fill_in 'Motivo', with: 'Atraso de pagamento'
    click_on 'Confirmar'

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'carl@sagan.com'
    expect(page).to have_content '28496429083'
    expect(page).to have_content 'CPF inativo'
    expect(page).to have_content 'O cliente se encontra bloqueado. Entre em contato com o nosso atendimento'
    expect(page).to have_content 'Motivo:'
    expect(page).to have_content 'Atraso de pagamento'
  end
  it 'e desbloqueia cliente' do
    # Arrange
    admin = create(:user)
    client = create(:client, eni: '28496429083', eni_status: :inactive)

    # Act
    login_as(admin)
    visit client_path(client.id)
    click_on 'Reativar CPF'

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'carl@sagan.com'
    expect(page).to have_content '28496429083'
    expect(page).to have_content 'CPF ativo'
    expect(page).to have_content 'Cliente desbloqueado com sucesso'
    expect(page).not_to have_content 'O cliente se encontra com o cadastro bloqueado, contate um administrador'
    expect(page).not_to have_content 'Motivo:'
    expect(page).not_to have_content 'Atraso de pagamento'
  end
end
