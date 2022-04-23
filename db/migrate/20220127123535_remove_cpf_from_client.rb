class RemoveCpfFromClient < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :cpf, :string
  end
end
