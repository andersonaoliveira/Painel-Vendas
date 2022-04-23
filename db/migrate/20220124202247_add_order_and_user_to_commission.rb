class AddOrderAndUserToCommission < ActiveRecord::Migration[6.1]
  def change
    add_reference :commissions, :order, null: false, foreign_key: true
    add_reference :commissions, :user, null: false, foreign_key: true
  end
end
