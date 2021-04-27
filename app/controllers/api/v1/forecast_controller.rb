class Api::V1::ForecastController < ApplicationController
  def index
    weather = ForecastFacade.weather(params[:location])
    render json: ForecastSerializer.new(weather)
  end
end