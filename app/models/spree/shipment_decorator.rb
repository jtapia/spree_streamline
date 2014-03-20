module Spree
  Shipment.class_eval do

    def send_shipped_email
      unless order.stock_removal
        Spree::ShipmentMailer.shipped_email(self.id).deliver
      end
    end

  end
end