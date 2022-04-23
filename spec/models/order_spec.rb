require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'campos obrigatórios' do
    it 'plan id é obrigatório' do
      client = create(:client)
      order = Order.new(period: 'Mensal', client: client)

      expect(order).not_to be_valid
    end

    it 'period é obrigatório' do
      client = create(:client)
      order = Order.new(plan_id: 1, client: client)

      expect(order).not_to be_valid
    end

    it 'cliente é obrigatório' do
      order = Order.new(period: 'Mensal', plan_id: 1)
      expect(order).not_to be_valid
    end
  end

  it 'pedido é criado automaticamente como pendente' do
    order = Order.new(period: 'Mensal', plan_id: 1)

    expect(order.pending?).to eq true
  end
end
