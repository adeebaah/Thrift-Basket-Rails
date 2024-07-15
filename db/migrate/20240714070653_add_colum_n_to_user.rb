class AddColumNToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :dob, :date
  end
end
