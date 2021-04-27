class RoadtripFacade

  def self.raw_trip_data(origin, destination)
    Faraday.get("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_KEY']}&from=#{origin}&to=#{destination}")
  end

  def self.trip_data(origin, destination)
    JSON.parse(raw_trip_data(origin, destination).body, symbolize_names: true)
  end

  def self.weather_data(origin, destination)
    latitude = trip_info(origin, destination).arrival_latitude
    longitude = trip_info(origin, destination).arrival_longitude

    OpenweatherService.parse_data(latitude, longitude)
  end
  
  def self.trip_info(origin, destination)
    route = trip_data(origin, destination)[:route]
    OpenStruct.new(
      start_city: origin,
      end_city: destination,
      travel_time: route[:formattedTime],
      raw_travel_time: route[:time],
      arrival_time: Time.now + route[:time],
      arrival_latitude: route[:locations].last[:displayLatLng][:lat],
      arrival_longitude: route[:locations].last[:displayLatLng][:lng]
    )
  end

  def self.forecast_data(origin, destination)
    trip_info = trip_info(origin, destination)
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
    trip_info = trip_info(origin, destination)
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
end