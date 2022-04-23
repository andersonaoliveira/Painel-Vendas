class AddEniToClient < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :eni, :string
  end
end
