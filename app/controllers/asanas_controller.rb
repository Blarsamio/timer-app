class AsanasController < ApplicationController
  def index
    asanas = Asana.all
    render json: asanas
  end

  def show
    asana = Asana.find(params[:id])
    render json: asana
  end
end
