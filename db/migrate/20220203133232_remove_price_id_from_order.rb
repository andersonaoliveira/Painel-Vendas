class RemovePriceIdFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :price_id, :integer
  end
end
