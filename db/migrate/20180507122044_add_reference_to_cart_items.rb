class AddReferenceToCartItems < ActiveRecord::Migration[5.1]
  def change
    add_reference    :cart_items, :service_option_time, foreign_key: true
    remove_reference :cart_items, :service_option_detail
  end
end
