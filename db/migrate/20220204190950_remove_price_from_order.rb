class RemovePriceFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :price, :decimal
  end
end
