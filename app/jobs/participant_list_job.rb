class ParticipantListJob < ActiveJob::Base
  queue_as :default

  def perform challenge, scheduled_at
    return if scheduled_at != challenge.updated_at.to_i

    challenge.users.each do |user|
      NotificationMailer.participant_list_email(user, challenge).deliver_later
    end
  end

end
