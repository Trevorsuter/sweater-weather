class SalariesFacade

  def self.get_weather_data(destination)
    coordinates = MapquestFacade.get_coordinates(destination)
    OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
  end
end