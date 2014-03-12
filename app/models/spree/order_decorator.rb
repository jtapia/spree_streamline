module Spree
  Order.class_eval do

    def deliver_order_confirmation_email
      unless through_admin
        super
      end
    end

  end
end