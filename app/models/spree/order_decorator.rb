module Spree
  Order.class_eval do

    def deliver_order_confirmation_email
      unless stock_removal
        begin
          Spree::OrderMailer.confirm_email(self.id).deliver
        rescue Exception => e
          logger.error("#{e.class.name}: #{e.message}")
          logger.error(e.backtrace * "\n")
        end
      end
    end

  end
end