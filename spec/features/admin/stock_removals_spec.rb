require 'spec_helper'

describe 'Stock Removals', :js => true do
  let!(:country) { create(:country, :name => "United States") }
  let!(:state) { create(:state, :name => "California", :country => country) }
  let!(:ship_address) { create(:address, :country => country, :state => state, :first_name => "Test") }
  let!(:bill_address) { create(:address, :country => country, :state => state, :first_name => "Test") }
  let!(:user) { create(:user, :email => 'foobar@example.com', :ship_address => ship_address, :bill_address => bill_address) }
  let!(:source) { create(:stock_location_with_items, :name => 'NY') }
  let!(:shipping_method){ create(:shipping_method) }
  let!(:payment_method) { create(:payment_method) }
  let(:gateway) do
    gateway = Spree::Gateway::Bogus.new({:environment => 'test', :active => true}, :without_protection => true)
    gateway.stub :source_required => true
    gateway
  end

  let(:card) do
    mock_model(Spree::CreditCard, :number => "4111111111111111",
                                  :has_payment_profile? => true)
  end

  stub_authorization!

  before do
    visit spree.new_admin_stock_removal_path
  end

  it 'should create a new stock removal order' do
    targetted_select2 'NY', :from => '#s2id_transfer_source_location_id'
    targetted_select2 'foobar@example.com', :from => '#s2id_customer_search'
    targetted_select2_search source.stock_items.first.variant.name, :from => '#s2id_transfer_variant'
    click_button "Add"
    click_button "Stock Removal"

    page.should have_content('Order has been successfully created!')
  end

  it 'should fails creating a new stock removal order' do
    Spree::PaymentMethod.destroy_all

    targetted_select2 'NY', :from => '#s2id_transfer_source_location_id'
    targetted_select2 'foobar@example.com', :from => '#s2id_customer_search'
    targetted_select2_search source.stock_items.first.variant.name, :from => '#s2id_transfer_variant'
    click_button "Add"
    click_button "Stock Removal"

    page.should have_content("Order can't be created, please check all the fields.")
  end
end
