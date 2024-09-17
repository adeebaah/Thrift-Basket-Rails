class AddStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:orders, :status)
      add_column :orders, :status, :string
    end
  end
end
