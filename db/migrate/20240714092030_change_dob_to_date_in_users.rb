class ChangeDobToDateInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :dob, 'date USING CAST(dob AS date)'
  end
end
