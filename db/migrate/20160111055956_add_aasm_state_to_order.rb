class AddAasmStateToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :aasm_state, :string, default: "order_placed"
  	# 加index，因為很常被查詢
  	add_index :orders, :aasm_state 
  end
end
