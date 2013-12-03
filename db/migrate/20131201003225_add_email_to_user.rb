class AddEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    remove_column :users, :oauth_expires_at
  end
end
