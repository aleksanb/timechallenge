class AddUserRefToChallenge < ActiveRecord::Migration
  def change
    add_reference :challenges, :user, index: true
  end
end
