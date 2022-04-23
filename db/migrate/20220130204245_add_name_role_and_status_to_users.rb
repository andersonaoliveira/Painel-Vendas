class AddNameRoleAndStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :status, :integer, default: 0
  end
end
