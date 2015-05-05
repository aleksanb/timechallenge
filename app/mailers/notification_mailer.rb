class NotificationMailer < ApplicationMailer
    default from: 'notifications@challenge.burkow.no'

    def attendants_email(@challenge)
        @challenge.users.each do |user|
            mail(to: user.email, subject: "Attendants for #{@challenge.title}")
        end
    end

end
