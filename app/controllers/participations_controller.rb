class ParticipationsController < ApplicationController
  def create
    @challenge = Challenge.find(params[:challenge_id])
    if current_user.challenges.include? @challenge
      flash[:failure] = 'You are allready attending'
      redirect_to @challenge
    else
      @participation = @challenge.participations.create
      current_user.participations << @participation
      redirect_to @challenge
    end
  end

  def destroy
    @challenge = Challenge.find(params[:challenge_id])
    current_user.challenges.destroy(@challenge)
    redirect_to @challenge
  end
end
