class AddDobTempToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dob_temp, :date
  end
end
