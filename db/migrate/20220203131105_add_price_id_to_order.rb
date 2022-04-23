class AddPriceIdToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :price_id, :integer
  end
end
