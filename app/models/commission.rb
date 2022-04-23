class Commission < ApplicationRecord
  DEFAULT_COMMISSION_TAX = 0.01

  belongs_to :order
  belongs_to :user

  def self.generate(order)
    return if order.user_id.nil?

    commission = Commission.find_by(order_id: order.id)
    if commission.nil?
      Commission.create(value: order.value * DEFAULT_COMMISSION_TAX, order_id: order.id, user_id: order.user_id)
    else
      commission.update(value: order.value * DEFAULT_COMMISSION_TAX, user_id: order.user_id)
    end
  end

  def self.clear(order)
    return if order.user_id.nil?

    commission = Commission.find_by(order_id: order.id)
    if commission.nil?
      Commission.create(value: 0, order_id: order.id, user_id: order.user_id)
    else
      commission.update(value: 0)
    end
  end
end
