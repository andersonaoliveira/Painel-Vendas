class RemoveEniStatusFromClients < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :eni_status, :boolean
  end
end
