class RemoveCpfStatus2FromClients < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :cpf_status, :integer
  end
end
