require 'rails_helper'

RSpec.describe Client, type: :model do
  context 'campos obrigatórios' do
    it 'eni é obrigatório' do
      client = Client.new(eni: '', name: 'Carlos', email: 'carlos@email.com')

      expect(client).not_to be_valid
    end

    it 'name é obrigatório' do
      client = Client.new(eni: '66899030012', name: '', email: 'carlos@email.com')

      expect(client).not_to be_valid
    end

    it 'email é obrigatório' do
      client = Client.new(eni: '66899030012', name: 'Carlos', email: '')

      expect(client).not_to be_valid
    end
  end

  context 'atributo único' do
    it 'eni deve ser único' do
      Client.create!(eni: '66899030012', name: 'Carlos', email: 'carlos@email.com')
      client2 = Client.new(eni: '66899030012', name: 'Roberto', email: 'roberto@email.com')

      expect(client2).not_to be_valid
    end
  end

  context 'atributo de tamanho inválido' do
    it 'eni tem tamanho inválido' do
      client = Client.new(eni: '66899030', name: 'Carlos', email: 'carlos@email.com')

      expect(client).not_to be_valid
    end
  end

  context 'eni é valido' do
    it 'eni possui formato de cpf' do
      client = Client.new(eni: '66899030012', name: 'Carlos', email: 'carlos@email.com')

      expect(client).to be_valid
    end

    it 'eni possui formato de cnpj' do
      client = Client.new(eni: '32586458000160', name: 'CarlosEnterprises', email: 'carlos@email.com')

      expect(client).to be_valid
    end

    it 'eni possui formato de cpf invalido' do
      client = Client.new(eni: '668990300132', name: 'Carlos', email: 'carlos@email.com')

      expect(client).not_to be_valid
    end

    it 'eni possui formato de cnpj invalido' do
      client = Client.new(eni: '32586458000161', name: 'CarlosEnterprises', email: 'carlos@empresa.com')

      expect(client).not_to be_valid
    end
  end
end
