class AsanasController < ApplicationController
  before_action :set_asana, only: [:show]
  
  def index
    asanas = Asana.all
    asanas = asanas.for_session(params[:session_id]) if params[:session_id]
    asanas = asanas.by_title(params[:search]) if params[:search].present?
    
    render_success(asanas.order(:title))
  end

  def show
    render_success(@asana)
  end
  
  private
  
  def set_asana
    @asana = Asana.find(params[:id])
  end
end
