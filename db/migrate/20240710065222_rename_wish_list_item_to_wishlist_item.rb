class RenameWishListItemToWishlistItem < ActiveRecord::Migration[7.1]
  def change
    rename_table :wish_list_items, :wishlist_items
  end
end
