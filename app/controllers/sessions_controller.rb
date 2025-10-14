class SessionsController < ApplicationController
  def index
    sessions = Session.includes(:timers).all
    render json: sessions.to_json(include: :timers)
  end

  def show
    session = Session.find(params[:id])
    render json: session.to_json(include: :timers)
  end

  def create
    session = Session.new(session_params)
    if session.save
      render_success(session, status: :created, message: 'Session created successfully')
    else
      render_error('Failed to create session', status: :unprocessable_entity, details: session.errors.full_messages)
    end
  end

  def update
    session = Session.find(params[:id])
    if session.update(session_params)
      render_success(session, message: 'Session updated successfully')
    else
      render_error('Failed to update session', status: :unprocessable_entity, details: session.errors.full_messages)
    end
  end

  def destroy
    session = Session.find(params[:id])
    session.destroy
    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(:name, :description)
  end
end
