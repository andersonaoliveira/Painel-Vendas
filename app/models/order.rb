class Order < ApplicationRecord
  enum status: { pending: 0, concluded: 2, canceled: 3 }

  validates :plan_id, :period, :client_eni, presence: true

  belongs_to :client
  belongs_to :user, optional: true
end
