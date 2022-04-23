class AddPeriodAgainToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :period, :string
  end
end
