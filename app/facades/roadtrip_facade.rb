class RoadtripFacade

  def self.weather_data(origin, destination)
    latitude = RoadtripService.data(origin, destination).arrival_latitude
    longitude = RoadtripService.data(origin, destination).arrival_longitude

    OpenweatherService.parse_data(latitude, longitude)
  end

  def self.forecast_data(origin, destination)
    trip_info = RoadtripService.data(origin, destination)
    weather_data = weather_data(origin, destination)
    if trip_info.raw_travel_time > 172800
      find_daily_forecast(weather_data[:daily], trip_info.arrival_time)
    else 
      find_hourly_forecast(weather_data[:hourly], trip_info.arrival_time)
    end
  end

  def self.find_daily_forecast(weather_info, arrival_time)
    weather_info.select do |day|
      Time.at(day[:dt]).day == arrival_time.day
    end.first
  end

  def self.find_hourly_forecast(weather_info, arrival_time)
    weather_info.select do |hour|
      (Time.at(hour[:dt]).hour == arrival_time.hour) && 
      (Time.at(hour[:dt]).day == arrival_time.day)
    end.first
  end

  def self.find_temp(origin, destination)
    temp = forecast_data(origin, destination)[:temp]
    if temp.class == Hash
      temp[:day]
    else
      temp
    end
  end

  def self.weather_at_eta(origin, destination)
    forecast_data = forecast_data(origin, destination)
    conditions = forecast_data[:weather].first[:description]
    temperature = find_temp(origin, destination)

    OpenStruct.new(temperature: temperature,
                  conditions: conditions)
  end

  def self.data(origin, destination)
    trip_info = RoadtripService.data(origin, destination)
    weather_info = weather_at_eta(origin, destination)

    OpenStruct.new(start_city: trip_info.start_city,
                  end_city: trip_info.end_city,
                  travel_time: trip_info.travel_time,
                  weather_at_eta: {
                    temperature: weather_info.temperature,
                    conditions: weather_info.conditions
                    }  
                  )
  end

  def self.bad_trip(origin, destination)
    RoadtripService.parsed_data(origin, destination)[:info][:messages].first
    
  end
end