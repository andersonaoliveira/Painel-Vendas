require 'rails_helper'

def api_check(path)
  Faraday.get(path)
  true
rescue StandardError
  false
end

describe 'Vendedor realiza pedido de um cliente' do
  api_produtos = api_check(Rails.configuration.apis['products_api'])
  api_pagamentos = api_check(Rails.configuration.apis['payments_api'])

  it 'com sucesso', js: true, if: api_produtos && api_pagamentos do
    # Arrange
    user = create(:user)
    client = create(:client)
    login_as(user)

    # Act
    visit root_path
    visit new_client_order_path(client.id)
    expect(page).to have_content 'Cadastro de novo pedido'
    select 'Email', from: 'Grupo'
    select 'Email Básica', from: 'Plano'
    select 'Semestral', from: 'Periodicidade'
    fill_in 'cupom_code', with: 'BORAGASTAR-3OOEXW'
    click_on 'Validar cupom'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Carl Sagan'
    expect(page).to have_content 'Alan Turing'
    expect(page).to have_content 'R$ 300,00'
    expect(page).to have_content 'R$ 100,00'
  end

  it 'mas o cupom não é válido', js: true, if: api_produtos && api_pagamentos do
    # Arrange
    user = create(:user)
    client = create(:client)
    login_as(user)

    # Act
    visit root_path
    visit new_client_order_path(client.id)
    expect(page).to have_content 'Cadastro de novo pedido'
    select 'Email', from: 'Grupo'
    select 'Email Básica', from: 'Plano'
    select 'Semestral', from: 'Periodicidade'
    fill_in 'cupom_code', with: 'klapaucius'
    click_on 'Validar cupom'

    # Assert
    expect(page).to have_content 'Cupom não encontrado'
  end

  it 'mas o cupom não é válido para este grupo de produtos', js: true, if: api_produtos && api_pagamentos do
    # Arrange
    user = create(:user)
    client = create(:client)
    login_as(user)

    # Act
    visit root_path
    visit new_client_order_path(client.id)
    expect(page).to have_content 'Cadastro de novo pedido'
    select 'Cloud', from: 'Grupo'
    select 'Virtualização Básica', from: 'Plano'
    select 'Semestral', from: 'Periodicidade'
    fill_in 'cupom_code', with: 'BORAGASTAR-3OOEXW'
    click_on 'Validar cupom'

    # Assert
    expect(page).to have_content 'O cupom não é válido para este grupo de produtos'
  end

  it 'sem preencher os selects', js: true, if: api_produtos && api_pagamentos do
    # Arrange
    user = create(:user)
    client = create(:client)
    login_as(user)

    # Act
    visit root_path
    visit new_client_order_path(client.id)
    click_on 'Salvar'

    # Assert
    expect(page).to have_css 'div#orderError', text: 'Grupo não pode ficar em branco'
    expect(page).to have_css 'div#orderError', text: 'Plano não pode ficar em branco'
    expect(page).to have_css 'div#orderError', text: 'Periodicidade não pode ficar em branco'
  end
end
