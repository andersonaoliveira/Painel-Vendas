class AddPeriodToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :period, :integer
  end
end
