class AddCancelReasonToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :cancellation_reason, :text, default: ''
  end
end
