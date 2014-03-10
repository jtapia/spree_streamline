FactoryGirl.define do
  factory :no_charge_method, class: Spree::PaymentMethod do
    name 'No Charge'
    environment 'test'
  end
end