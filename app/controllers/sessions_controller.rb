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
      render json: session, status: :created
    else
      render json: session.errors, status: :unprocessable_entity
    end
  end

  def update
    session = Session.find(params[:id])
    if session.update(session_params)
      render json: session
    else
      render json: session.errors, status: :unprocessable_entity
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
