require 'rails_helper'

describe 'Administrador visualiza todos os clientes' do
  it 'com sucesso' do
    # Arrange
    user = create(:user)
    afonso = create(:client, name: 'Afonso Ferreira', email: 'afonso@email.com')
    julia = create(:client, eni_status: :inactive, name: 'Julia Brasao', email: 'julia@email.com', eni: '85638621032')

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'

    # Assert
    within('table#active-clients') do
      within("tr#client-#{afonso.id}") do
        expect(page).to have_css 'td', text: 'Afonso Ferreira'
        expect(page).to have_css 'td', text: 'afonso@email.com'
      end
    end
    within('table#inactive-clients') do
      within("tr#client-#{julia.id}") do
        expect(page).to have_css 'td', text: 'Julia Brasao'
        expect(page).to have_css 'td', text: 'julia@email.com'
      end
    end
  end

  it 'e não existem clientes cadastrados' do
    # Arrange
    user = create(:user)

    # Act
    login_as(user)
    visit root_path
    click_on 'Clientes'

    # Assert
    expect(page).to have_css 'h2', text: 'Nenhum cliente cadastrado'
    expect(page).not_to have_css 'tr', text: 'Nome'
    expect(page).not_to have_css 'tr', text: 'E-mail'
  end

  it 'mas não está logado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_css 'a', text: 'Clientes'
  end

  it 'e não consegue acessar a página de clientes sem estar logado' do
    # Arrange

    # Act
    visit clients_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end
