# == Schema Information
#
# Table name: challenges
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  deadline    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  reward      :string(255)
#  building_id :integer
#  room_id     :integer
#

class Challenge < ActiveRecord::Base
  extend TimeSplitter::Accessors

  has_many :participations
  has_many :users, through: :participations

  validates_presence_of :title, :deadline, :reward

  split_accessor :deadline, default: -> { DateTime.current }

  def to_param
    super.to_param + '-' + title.parameterize
  end

end
