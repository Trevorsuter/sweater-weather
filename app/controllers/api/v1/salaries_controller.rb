class Api::V1::SalariesController < ApplicationController

  def index
    teleport_response = Faraday.get("https://api.teleport.org/api/urban_areas/slug:#{params[:destination]}/salaries")
    coordinates = MapquestFacade.get_coordinates(params[:destination])
    current_weather = OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
    result = JSON.parse(teleport_response.body, symbolize_names: true)
    binding.pry
    render json: {}
  end

  def formatted_output(forecast, salaries)
    output = { data: {
                id: nil,
                type: "salaries",
                attributes: {
                  destination: params[:destination],
                  forecast: {
                    summary: forecast['conditions'],
                    temperature: forecast['temperature']
                  }
                  salaries: salaries
                } 
    }}
  end
end