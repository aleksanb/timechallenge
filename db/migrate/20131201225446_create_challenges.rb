class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.datetime :deadline

      t.timestamps
    end
  end
end
