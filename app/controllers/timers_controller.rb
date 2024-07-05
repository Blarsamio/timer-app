class TimersController < ApplicationController
  def create
    session = Session.find(params[:session_id])
    timer = session.timers.new(timer_params)
    if timer.save
      render json: timer, status: :created
    else
      render json: timer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    timer = Timer.find(params[:id])
    timer.destroy
    head :no_content
  end

  private

  def timer_params
    params.require(:timer).permit(:duration)
  end
end
