class SalariesFacade

  def self.get_weather_data(destination)
    coordinates = MapquestFacade.get_coordinates(destination)
    OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
  end

  def self.format_jobs(destination)
    data = SalariesService.find_correct_jobs(destination)
    data.map do |d|
      OpenStruct.new(title: d[:job][:title],
                    min: d[:salary_percentiles][:percentile_25],
                    max: d[:salary_percentiles][:percentile_75]
                    ).as_json['table']
    end
  end
end