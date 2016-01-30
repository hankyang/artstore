class Cart < ActiveRecord::Base
	has_many :cart_items, dependent: :destroy
	has_many :items, through: :cart_items, source: :product

	def find_cart_item(product)
		cart_items.find_by(product_id: product)
	end

	def add_product_to_cart(product)
		# "<<" 就是 "push"
		items << product
#		ci = cart_items.build
#		ci.product = product
#		ci.save
	end

	# 把加總放在model method，可被cache 住，節省記憶的使用
	# （view 的code 不會被cache）
	def total_price
		cart_items.inject(0) { |sum, cart_item| sum + (cart_item.product.price * cart_item.quantity) }
#		items.inject(0)	{ |sum, item| sum + item.price}

#		sum = 0
#		items.each do |item|
#			sum = sum + item.price
#		end

#		return sum

	end

	def clean!
		cart_items.destroy_all
	end
end
