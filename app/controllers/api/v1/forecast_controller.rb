class Api::V1::ForecastController < ApplicationController
  def index
    coordinates = MapquestFacade.get_coordinates(params[:location])
    weather = OpenweatherFacade.data(coordinates.latitude, coordinates.longitude)

    render json: forecast_output(weather.current, weather.daily, weather.hourly)
  end

  private

  def forecast_output(current, daily, hourly)
    output = {data: {
        id: nil,
        type: "forecast",
        attributes: {
          current_weather: current,
          daily_weather: daily,
          hourly_weather: hourly
          }
        }
      }
    output.to_json
  end
end