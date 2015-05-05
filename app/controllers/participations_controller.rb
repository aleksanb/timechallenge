class ParticipationsController < ApplicationController

  def create
    @challenge = Challenge.find(params[:challenge_id])

    participation = @challenge.participations.build(user: current_user)
    if participation.save
      flash[:success] = "You are now attending this challenge."
      @challenge.users.each do |user|
        NotificationMailer.participant_list_email(user, @challenge).deliver_now
      end
    else
      flash[:error] = "Failed to attend challenge. "
      flash[:error] << participation.errors.full_messages.join(" ")
    end

    redirect_to @challenge
  end

  def destroy
    @challenge = Challenge.find(params[:challenge_id])
    current_user.challenges.destroy(@challenge)

    @challenge.users.each do |user|
      NotificationMailer.participant_list_email(user, @challenge).deliver_now
    end

    flash[:success] = "You are no longer attending this challenge."
    redirect_to @challenge
  end
end
