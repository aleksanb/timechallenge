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

  has_many :participations
  has_many :users, through: :participations
  belongs_to :user

  default_scope { order(deadline: :asc) }
  scope :upcoming, -> { where("deadline > ?", Date.current) }

  validates :title, :deadline, :reward, :user, :location, presence: true
  validates :deadline,
    date: { after: Proc.new { Date.current }}

  split_accessor :deadline, default: -> { DateTime.current }

  after_commit :schedule_participant_list_task, if: ->(record) { record.previous_changes.any? }

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
    deadline - 5.hours
  end

  private

  def schedule_participant_list_task
    ParticipantListJob
      .set(wait_until: participation_deadline)
      .perform_later(self, updated_at.to_i)
  end

end
