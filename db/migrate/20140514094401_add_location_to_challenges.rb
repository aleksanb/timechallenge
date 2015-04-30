class AddLocationToChallenges < ActiveRecord::Migration

  def change
    add_column :challenges, :location, :string
  end

end
