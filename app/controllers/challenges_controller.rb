class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.all
  end

  def show
    @challenge = Challenge.find params[:id]
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.create(challenge_params)
    if @challenge.save
      flash[:success] = "Challenge successfully created."
      redirect_to @challenge
    else
      flash.now[:error] = "Error: Challenge not created."
      render :new
    end
  end

  def destroy
    challenge = Challenge.find params[:id]
    challenge.delete

    flash[:success] = "Challenge destroyed."
    redirect_to challenges_path
  end

  private
  def challenge_params
    params.require(:challenge)
      .permit(:title, :reward, :deadline_time, :deadline_date, :building_id, :room_id)
  end
end
