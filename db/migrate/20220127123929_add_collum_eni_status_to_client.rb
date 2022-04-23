class AddCollumEniStatusToClient < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :eni_status, :boolean
  end
end
