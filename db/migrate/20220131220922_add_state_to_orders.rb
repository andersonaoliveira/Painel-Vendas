class AddStateToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :state, :integer, default: 0
  end
end
