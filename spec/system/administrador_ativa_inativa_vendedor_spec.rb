require 'rails_helper'

describe 'Administrador visualiza detalhes de um vendedor' do
  it 'com sucesso' do
    # Arrange
    admin = create(:user, role: :admin)
    seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br')

    # Act
    login_as(admin)
    visit sellers_path
    within("tr#seller-#{seller.id}") do
      click_on 'Rogério'
    end

    # Assert
    expect(page).to have_css('h2', text: 'Rogério')
    expect(page).to have_content 'roro@locaweb.com.br'
    expect(page).to have_content 'Ativo'
    expect(page).to have_button 'Desativar vendedor'
  end

  it 'e muda seu Status para Inativo' do
    admin = create(:user, role: :admin)
    seller = create(:user, role: :salesperson)

    # Act
    login_as(admin)
    visit sellers_path
    within("tr#seller-#{seller.id}") do
      click_on 'Alan Turing'
    end
    click_on 'Desativar vendedor'

    # Assert
    expect(current_path).to eq seller_path(seller.id)
    expect(page).to have_content 'Inativo'
  end

  it 'e volta seu Status para ativo' do
    admin = create(:user, role: :admin)
    seller = create(:user, role: :salesperson, name: 'Rogério', email: 'roro@locaweb.com.br', status: :inactive)

    # Act
    login_as(admin)
    visit sellers_path
    within("tr#seller-#{seller.id}") do
      click_on 'Rogério'
    end
    click_on 'Ativar vendedor'

    # Assert
    expect(current_path).to eq seller_path(seller.id)
    expect(page).to have_content 'Ativo'
  end
end
