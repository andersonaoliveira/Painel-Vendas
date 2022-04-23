class AddCpfStatusToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :cpf_status, :integer
  end
end
