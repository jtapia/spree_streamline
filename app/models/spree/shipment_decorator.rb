module Spree
  Shipment.class_eval do

    def send_shipped_email
      unless order.through_admin
        super
      end
    end

  end
end