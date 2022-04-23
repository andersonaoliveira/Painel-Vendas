class AddValueToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :value, :decimal
  end
end
