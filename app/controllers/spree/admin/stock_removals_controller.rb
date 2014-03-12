module Spree
  module Admin
    class StockRemovalsController < Spree::Admin::OrdersController
      before_filter :load_data, only: :create

      def new; end

      def create
        begin
          associate_user
          assign_address
          create_shipment
          order_next_state
          create_payment
          order_next_state
          finalize_order!
          order_next_state
          finalize_shipment!
        rescue
          flash[:error] = Spree.t(:order_error)
          redirect_to :action => :new
          return
        end

        redirect_to admin_orders_path
        flash[:success] = Spree.t(:order_successfully_created)
      end

      private

      def load_order
        @order = Spree::Order.create
        @order.created_by = try_spree_current_user
        @order.stock_removal = true
        @order.save
      end

      def load_data
        load_order
        @user = Spree::User.find_by_id params[:customer_search]
        @stock_location = Spree::StockLocation.find_by_id params[:transfer_source_location_id]
        @variants = params[:variant]
        @quantities = params[:quantity]
        @payment = Spree::PaymentMethod.available.first
      end

      def create_shipment
        shipment = @order.shipments.create stock_location_id: @stock_location.id
        @variants.each_with_index do |variant_id, i|
          variant = Spree::Variant.find_by_id variant_id
          @order.contents.add(variant, @quantities[i], nil, shipment)
        end
        shipment.refresh_rates
        shipment.save!
        @order.save!
      end

      def associate_user
        @order.associate_user!(@user)
        @order.save!
      end

      def assign_address
        @order.ship_address = @user.ship_address
        @order.bill_address = @user.bill_address
        @order.refresh_shipment_rates
        @order.save
        @order.reload
      end

      def create_payment
        payment_data = {
          amount: @order.total.to_f,
          payment_method_id: @payment.id
        }
        payment = @order.payments.build(payment_data)
        payment.save!
      end

      def order_next_state
        case @order.state
          when 'cart', 'address', 'delivery'
            until @order.payment?
              @order.next
            end
          when 'payment'
            until @order.completed?
              @order.next!
            end
          when 'completed'
            until @order.shipped?
              @order.next!
            end
        end
      end

      def finalize_order!
        @order.touch
        @order.update!
        @order.reload
      end

      def finalize_shipment!
        @order.shipment.ship!
        @order.reload
      end

      def model_class
        Spree::Order
      end

    end
  end
end
