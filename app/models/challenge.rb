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
#

class Challenge < ActiveRecord::Base
  extend TimeSplitter::Accessors

  DEADLINE_HOURS = 1

  has_many :participations
  has_many :users, through: :participations
  belongs_to :user

  scope :upcoming, -> { where("deadline >= ?", DateTime.current) }
  scope :ordered, -> { order(deadline: :asc) }

  validates :title, :deadline, :reward, :user, :location, presence: true
  validates :deadline,
    date: { after: Proc.new { Date.current }}

  split_accessor :deadline, default: -> { DateTime.current }

  def to_param
    "#{super.to_param}-#{title}".parameterize
  end

  def attendable? user
    user &&
      Time.current < participation_deadline &&
      users.exclude?(user)
  end

  def unattendable? user
    user &&
      Time.current < participation_deadline &&
      users.include?(user)
  end

  def participation_deadline
    deadline.change(hour: Challenge::DEADLINE_HOURS)
  end

end
