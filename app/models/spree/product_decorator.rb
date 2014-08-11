Spree::Product.class_eval do

  # Add inactive products scope to the search scope
  add_search_scope :without_inactive do
    where("#{Spree::Product.table_name}.inactive = ?", false)
  end

  add_search_scope :with_inactive do
    where("#{Spree::Product.table_name}.inactive = ?", true)
  end

end