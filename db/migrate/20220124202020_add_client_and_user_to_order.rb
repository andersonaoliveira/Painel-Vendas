class AddClientAndUserToOrder < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :client, null: false, foreign_key: true
    add_reference :orders, :user, foreign_key: true
  end
end
