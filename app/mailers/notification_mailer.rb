class NotificationMailer < ActionMailer::Base
    default from: 'notifications@challenge.burkow.no'

    def participant_list_email(user, challenge)
        @user = user
        @challenge = challenge
        mail(to: user.email, subject: "Participant list for challenge '#{challenge.title}'")
    end

end
