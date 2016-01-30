class Order < ActiveRecord::Base

	belongs_to :user

	# "class_name" 可針對"has_many" 或 "has_one"去將型態指定至特定的class 裡
	#（這裡是"Order"，可以改成其他的）
	has_many :items, class_name: "OrderItem", dependent: :destroy
	has_one  :info,  class_name: "OrderInfo", dependent: :destroy

	#nested_form 卡關001
	accepts_nested_attributes_for :info

	include AASM

	aasm do
		state :order_placed, initial: true
		state :paid
		state :shipping
		state :shipped
		state :order_cancelled
		state :good_returned


		event :make_payment, :after_commit => :pay! do
			transitions from: :order_placed, to: :paid
		end

		event :ship do
			transitions from: :paid, to: :shipping
		end

		event :deliver do
			transitions from: :shipping, to: :shipped
		end

		event :return_good do
			transitions from: :shipped, to: :good_returned
		end

		event :cancell_order do
			transitions from: [:order_placed, :paid], to: :order_cancelled
		end
	end


	include Tokenable

	def build_item_cache_from_cart(cart)
		cart.items.each do |cart_item|
			item = items.build
			item.product_name = cart_item.title
			item.quantity = cart.find_cart_item(cart_item).quantity 
			item.price = cart_item.price
			item.save
		end
	end

	def calculate_total!(cart)
		self.total = cart.total_price
		self.save
	end

	def set_payment_with!(method)
		self.update_columns(payment_method: method)
	end

	def pay!
		self.update_columns(is_paid: true)
	end
end 