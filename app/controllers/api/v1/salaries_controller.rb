class Api::V1::SalariesController < ApplicationController

  def index
    jobs = SalariesService.format_jobs(params[:destination])
    current_weather = SalariesFacade.get_weather_data(params[:destination])

    render json: formatted_output(current_weather, jobs)
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
                  },
                  salaries: salaries
                } 
    }}.to_json
  end
end