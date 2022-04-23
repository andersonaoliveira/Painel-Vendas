class ChangeClientIdNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :orders, :client_id, true
  end
end
