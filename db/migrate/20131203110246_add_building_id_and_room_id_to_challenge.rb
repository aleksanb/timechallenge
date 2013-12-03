class AddBuildingIdAndRoomIdToChallenge < ActiveRecord::Migration
  def change
    add_reference :challenges, :building, index: true
  end
end
