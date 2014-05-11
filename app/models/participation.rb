# == Schema Information
#
# Table name: participations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  validates_presence_of :user, :challenge

  validate :timechallenge_date_passed, if: :new_record?
  validate :timechallenge_contains_user, if: :new_record?

  before_destroy :timechallenge_date_passed

  private

  def timechallenge_date_passed
    if Time.current >= challenge.participation_deadline
      errors.add(:base, "This challenge has begun, no changes in participants are allowed.")
    end

    errors.blank?
  end

  def timechallenge_contains_user
    if challenge.users.include? user
      errors.add(:base, "You are allready attending this challenge.")
    end

    errors.blank?
  end
end
