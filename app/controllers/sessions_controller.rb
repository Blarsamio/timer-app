# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    sessions = Session.includes(:timers).all
    render_success(SessionBlueprint.render_as_hash(sessions, view: :with_timers))
  end

  def show
    session = Session.find(params[:id])
    render_success(SessionBlueprint.render_as_hash(session, view: :with_timers))
  end

  def create
    session = Session.new(session_params)
    if session.save
      render_success(SessionBlueprint.render_as_hash(session), status: :created, message: "Session created successfully")
    else
      render_error("Failed to create session", status: :unprocessable_entity, details: session.errors.full_messages)
    end
  end

  def update
    session = Session.find(params[:id])

    # Check authorization based on device_id
    if session.device_id.present? && session.device_id != params[:device_id]
      render_error("Unauthorized to edit this session", status: :forbidden)
      return
    end

    if session.update(session_params)
      render_success(SessionBlueprint.render_as_hash(session, view: :with_timers), message: "Session updated successfully")
    else
      render_error("Failed to update session", status: :unprocessable_entity, details: session.errors.full_messages)
    end
  end

  def destroy
    session = Session.find(params[:id])
    session.destroy
    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(:name, :description, :device_id, timers_attributes: [:id, :duration, :title])
  end
end
