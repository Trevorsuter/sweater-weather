class Api::V1::ForecastController < ApplicationController
  def index
    weather = OpenweatherService.all_weather(params[:location])
    render json: ForecastSerializer.new(weather)
  end
end