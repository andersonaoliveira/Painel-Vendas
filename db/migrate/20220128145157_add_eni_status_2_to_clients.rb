class AddEniStatus2ToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :eni_status, :integer, default: 1
  end
end
