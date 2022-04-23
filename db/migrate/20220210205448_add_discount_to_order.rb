class AddDiscountToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :discount, :decimal
  end
end
