class AddClientEniToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :client_eni, :string
  end
end
