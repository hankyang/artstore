class OrdersController < ApplicationController
	before_action :authenticate_user!, except: [:pay2go_cc_notify, :pay2go_atm_complete]

	protect_from_forgery expect: [:pay2go_cc_notify, :pay2go_atm_complete]

	def show
		@order = Order.find(params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end

	def create
		@order = current_user.orders.build(order_params)

		if @order.save
			OrderPlacingService.new(current_cart, @order).place_order!

			redirect_to order_path(@order.token)
		else
			render "carts/checkout"
		end
	end

	def show
		@order = Order.find_by_token(params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end

	def pay_with_credit_card
		@order = Order.find_by_token(params[:id])
		@order.set_payment_with!("credit_card")
		#@order.make_payment 之後有沒有加驚嘆號似乎有差異... hcb
		@order.make_payment!

		redirect_to account_orders_path, notice: "成功完成付款"
	end

	def pay2go_cc_notify
		@order = Order.find_by_token(params[:id])

		if params["Status"] == "SUCCESS"

			@order.make_payment!
			if @order.is_paid?
				flash[:notice] = "以信用卡付帳成功"
				redirect_to account_orders_path
			else
				render text: "信用卡失敗"
			end
		else
			render text:"交易失敗"
		end
	end

	def pay2go_atm_complete
		@order = Order.find_by_token(params[:id])

		json_data = JSON.parse(params["JSONData"])

		if json_data["Status"] == "SUCCESS"

			@order.set_payment_with!("atm")
			@order.make_payment!

			render text: "交易成功"
		else
			render text: "交易失敗"
		end
	end


	private

	def order_params
		#nested_form 卡關002
		params.require(:order).permit(info_attributes: [:billing_name, :billing_address, :shipping_name, :shipping_address])
	end

end