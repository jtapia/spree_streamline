module Spree
  Order.class_eval do
    attr_accessible :payment_method, :payments_attributes
    # validates :user, presence: true, if: :stock_removal?
    # validates :payments, presence: true, if: :stock_removal?
    # validates :line_items, presence: true, if: :stock_removal?

    # private

    # def stock_removal?
    #   self.stock_removal == true
    # end
  end
end