class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :state
      t.integer :plan_id
      t.integer :cupom_id
      t.text :cancelation_reason, default: ''  

      t.timestamps
    end
  end
end
