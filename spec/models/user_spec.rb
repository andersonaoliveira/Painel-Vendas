require 'rails_helper'

RSpec.describe User, type: :model do
  context 'campos obrigatórios' do
    it 'nome é obrigatório' do
      user = User.new(name: '', email: 'carlos@locaweb.com.br', password: '12345678',
                      password_confirmation: '12345678')

      expect(user).not_to be_valid
    end

    it 'email é obrigatório' do
      user = User.new(name: 'Carlos Gomes', email: '', password: '12345678',
                      password_confirmation: '12345678')

      expect(user).not_to be_valid
    end

    it 'senha é obrigatória' do
      user = User.new(name: 'Carlos Gomes', email: 'carlos@locaweb.com.br', password: '',
                      password_confirmation: '12345678')

      expect(user).not_to be_valid
    end
  end

  context 'atributo inválido' do
    it 'email é único' do
      User.create!(name: 'Carlos Gomes', email: 'carlos@locaweb.com.br', password: '12345678',
                   password_confirmation: '12345678')
      user = User.new(name: 'Carlos Lacerda', email: 'carlos@locaweb.com.br', password: '12345678',
                      password_confirmation: '12345678')

      expect(user).not_to be_valid
    end

    it 'senha menor que 6 dígitos' do
      user = User.new(name: 'Carlos Gomes', email: 'carlos@locaweb.com.br', password: '12345',
                      password_confirmation: '12345')

      expect(user).not_to be_valid
    end

    it 'senha e confirmação tem que ser iguais' do
      user = User.new(name: 'Carlos Gomes', email: 'carlos@locaweb.com.br', password: '12345678',
                      password_confirmation: '12345679')

      expect(user).not_to be_valid
    end
  end

  it 'senha e confirmação tem que ser iguais' do
    seller = User.new(name: 'carlos', email: 'carlos@locaweb.com.br', password: '12345678',
                      password_confirmation: '12345679', role: :salesperson)

    expect(seller).not_to be_valid
  end

  context 'mudança de Status' do
    it 'Vendedor é criado ativo por padrão' do
      seller = User.create!(name: 'carlos', email: 'carlos@locaweb.com.br', password: '12345678',
                            password_confirmation: '12345678', role: 'salesperson')

      expect(seller.active?).to eq true
    end

    it 'Vendedor pode se tornar inativo' do
      seller = User.create!(name: 'carlos', email: 'carlos@locaweb.com.br', password: '12345678',
                            password_confirmation: '12345678', role: 'salesperson')

      seller.inactive!

      expect(seller.inactive?).to eq true
    end

    it 'Vendedor pode voltar a se tornar ativo' do
      seller = User.create!(name: 'carlos', email: 'carlos@locaweb.com.br', password: '12345678',
                            password_confirmation: '12345678', role: 'salesperson',
                            status: :inactive)

      seller.active!

      expect(seller.active?).to eq true
    end
  end
end
