class SalariesFacade

  def self.get_weather_data(destination)
    coordinates = MapquestFacade.get_coordinates(destination)
    OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
  end

  def self.generate_combined_data(destination)
    weather_data = get_weather_data(destination)
      OpenStruct.new(destination: destination,
      forecast: {
        summary: weather_data['conditions'],
        temperature: weather_data['temperature']
      },
      salaries: SalariesService.format_jobs(destination)
      )
  end
end