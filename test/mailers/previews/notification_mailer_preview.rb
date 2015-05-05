class NotificationMailerPreview < ActionMailer::Preview

  def participant_list_email
    @user = User.first
    @challenge = Challenge.first
    NotificationMailer.participant_list_email(@user, @challenge)
  end

end
