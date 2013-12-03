class AddBuildingIdAndRoomIdToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :building_id, :integer
    add_column :challenges, :room_id, :integer
  end
end
