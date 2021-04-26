class Api::V1::SalariesController < ApplicationController

  def index
    jobs = SalariesFacade.correct_jobs(params[:destination])
    current_weather = SalariesFacade.get_weather_data(params[:destination])
    formatted_jobs = format_jobs(jobs)

    render json: formatted_output(current_weather, formatted_jobs)
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

  def format_jobs(data)
    data.map do |d|
      OpenStruct.new(title: d[:job][:title],
                    min: d[:salary_percentiles][:percentile_25],
                    max: d[:salary_percentiles][:percentile_75]
                    ).as_json['table']
    end
  end
end