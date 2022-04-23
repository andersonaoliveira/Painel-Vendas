class RemoveCpfStatusFromClient < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :cpf_status, :boolean
  end
end
