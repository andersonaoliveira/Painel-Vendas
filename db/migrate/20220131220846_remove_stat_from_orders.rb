class RemoveStatFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :state, :integer
  end
end
