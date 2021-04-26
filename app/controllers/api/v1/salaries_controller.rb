class Api::V1::SalariesController < ApplicationController

  def index
    teleport_response = SalariesFacade.get_salary_data(params[:destination])
    coordinates = MapquestFacade.get_coordinates(params[:destination])
    current_weather = OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
    result = JSON.parse(teleport_response.body, symbolize_names: true)
    correct_jobs = find_correct_jobs(result[:salaries])
    formatted_jobs = format_jobs(correct_jobs)

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

  def find_correct_jobs(data)
    data.find_all do |d|
      allowed_jobs.include?(d[:job][:title].downcase)
    end
  end

  def allowed_jobs
    ["data analyst", 
    "data scientist", 
    "mobile developer", 
    "qa engineer", 
    "software engineer", 
    "systems administrator", 
    "web developer"]
  end
end