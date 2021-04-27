class ForecastFacade

  def self.coordinates(location)
    MapquestService.coordinates(location)
  end

  def self.weather(location)
    OpenweatherService.all_weather(coordinates(location).latitude, 
                                    coordinates(location).longitude)
  end
end