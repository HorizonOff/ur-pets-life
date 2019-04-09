class AddReferenceToShoppingCartItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :shopping_cart_items, :recurssion_intervals, foreign_key: true
  end
end
