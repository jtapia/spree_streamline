class AddStockRemovalFlagToOrdersTable < ActiveRecord::Migration
  def change
    add_column :spree_orders, :stock_removal, :boolean, default: false
  end
end
