class ParticipationsController < ApplicationController

  def create
    @challenge = Challenge.find(params[:challenge_id])

    participation = @challenge.participations.build(user: current_user)
    if participation.save
      flash[:success] = "You are now attending this challenge."
    else
      flash[:error] = "Failed to attend challenge. "
      flash[:error] << participation.errors.full_messages.join(" ")
    end

    redirect_to @challenge
  end

  def destroy
    @challenge = Challenge.find(params[:challenge_id])
    current_user.challenges.destroy(@challenge)

    flash[:success] = "You are no longer attending this challenge."
    redirect_to @challenge
  end
end
