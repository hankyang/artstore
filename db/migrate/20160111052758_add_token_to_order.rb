class AddTokenToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :token, :string
  	# 加index，因為很常被查詢
  	add_index :orders, :token
  end
end
