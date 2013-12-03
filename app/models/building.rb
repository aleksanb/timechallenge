# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  building_id :integer
#  nr          :string(255)
#  name        :string(255)
#  address     :string(255)
#  built_year  :integer
#  campus_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Building < ActiveRecord::Base
  has_many :challenges
end
