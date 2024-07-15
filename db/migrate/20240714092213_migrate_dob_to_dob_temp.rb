class MigrateDobToDobTemp < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      if user.dob.present?
        begin
          user.update_column(:dob_temp, Date.parse(user.dob))
        rescue ArgumentError
          # handle invalid date format if necessary
        end
      end
    end
  end

  def down
    User.update_all(dob_temp: nil)
  end
end

