class AddLocationToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :location, :string

    User.all.each do |u|
      u.location = "Remember to update the location!"
      u.save
    end
  end
end
