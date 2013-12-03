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
end
