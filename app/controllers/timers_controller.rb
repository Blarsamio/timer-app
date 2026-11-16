# frozen_string_literal: true

class TimersController < ApplicationController
  def create
    session = Session.find(params[:session_id])
    return forbidden unless session.editable_by?(params[:device_id])

    timer = session.timers.new(timer_params)
    if timer.save
      render_success(TimerBlueprint.render_as_hash(timer), status: :created, message: "Timer created successfully")
    else
      render_error("Failed to create timer", status: :unprocessable_entity, details: timer.errors.full_messages)
    end
  end

  def destroy
    timer = Timer.find(params[:id])
    return forbidden unless timer.session.editable_by?(params[:device_id])

    timer.destroy
    head :no_content
  end

  private

  def forbidden
    render_error("Unauthorized to edit this session", status: :forbidden)
  end

  def timer_params
    params.require(:timer).permit(:duration, :title)
  end
end
