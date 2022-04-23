class RemoveCuponIdFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :cupom_id, :integer
  end
end
