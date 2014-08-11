class AddInactiveToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :inactive, :boolean, default: false
  end
end
