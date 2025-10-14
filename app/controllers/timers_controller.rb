class TimersController < ApplicationController
  def create
    session = Session.find(params[:session_id])
    timer = session.timers.new(timer_params)
    if timer.save
      render_success(timer, status: :created, message: 'Timer created successfully')
    else
      render_error('Failed to create timer', status: :unprocessable_entity, details: timer.errors.full_messages)
    end
  end

  def destroy
    timer = Timer.find(params[:id])
    timer.destroy
    head :no_content
  end

  private

  def timer_params
    params.require(:timer).permit(:duration, :title)
  end
end
