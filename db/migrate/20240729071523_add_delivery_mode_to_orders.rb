class AddDeliveryModeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :delivery_mode, :string
  end
end
