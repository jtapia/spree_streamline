module Spree
  module Admin
    class StockRemovalsController < Spree::Admin::OrdersController
      before_filter :load_data, only: :create

      def new; end

      def create
        begin
          create_shipment
          associate_user
          assign_address
          order_next_state
          create_payment
          order_next_state
          finalize!
          order_next_state
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
        @order.through_admin = true
        @order.group_shipment = true
        @order.save
      end

      def load_data
        load_order
        @stock_location = Spree::StockLocation.find_by_id params[:transfer_source_location_id]
        @user = Spree::User.find_by_id params[:customer_search]
        @note = params[:no_charge_note]
        @code = params[:no_charge_code]
        @variant = Spree::Variant.find_by_id params[:transfer_variant]
        @quantity = params[:transfer_variant_quantity]
        @payment = Spree::PaymentMethod.find_by_name("No Charge")
      end

      def create_shipment
        shipment = @order.shipments.create stock_location_id: @stock_location.id
        @order.contents.add(@variant, @quantity, nil, shipment)
        shipment.refresh_rates
        shipment.save!
        @order.save!
      end

      def associate_user
        @order.associate_user!(@user)
        @order.save!
        @order.refresh_shipment_rates
        @order.reload
      end

      def assign_address
        @order.ship_address = @user.ship_addresses.first
        @order.bill_address = @user.bill_addresses.first
        @order.save
      end

      def create_payment
        payment_data = {
          amount: @order.total.to_f,
          payment_method_id: @payment.id,
          no_charge_note: @note,
          no_charge_code: @code
        }
        payment = @order.payments.build(payment_data)
        payment.save
      end

      def order_next_state
        case @order.state
          when 'cart', 'address'
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

      def finalize!
        @order.touch
        @order.update!
        @order.reload
      end

      def model_class
        Spree::Order
      end

    end
  end
end
