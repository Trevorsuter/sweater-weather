class OpenweatherService

  def self.get_data(location)
    coordinates = MapquestService.coordinates(location)
    Faraday.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{coordinates.latitude}&lon=#{coordinates.longitude}&exclude=minutely,alerts&units=imperial&appid=#{ENV['OPENWEATHER_KEY']}")
  end

  def self.parse_data(location)
    JSON.parse(get_data(location).body, symbolize_names: true)
  end

  def self.current_weather_data(location)
    parse_data(location)[:current]
  end

  def self.daily_weather_data(location)
    parse_data(location)[:daily][0..4]
  end

  def self.hourly_weather_data(location)
    parse_data(location)[:hourly][0..7]
  end

  def self.current_weather(location)
    data = current_weather_data(location)
    OpenStruct.new(datetime: Time.at(data[:dt]),
                    sunrise: Time.at(data[:sunrise]),
                    sunset: Time.at(data[:sunset]),
                    temperature: data[:temp],
                    feels_like: data[:feels_like],
                    humidity: data[:humidity],
                    uvi: data[:uvi],
                    visibility: data[:visibility],
                    conditions: data[:weather].first[:description],
                    icon: data[:weather].first[:icon]
    ).as_json['table']
  end

  def self.daily_weather(location)
    data = daily_weather_data(location)

    data.map do |day|
      OpenStruct.new(date: Time.at(day[:dt]).strftime('%F'),
                      sunrise: Time.at(day[:sunrise]),
                      sunset: Time.at(day[:sunset]),
                      max_temp: day[:temp][:max],
                      min_temp: day[:temp][:min],
                      conditions: day[:weather].first[:description],
                      icon: day[:weather].first[:icon]
                      ).as_json['table']
    end
  end

  def self.hourly_weather(location)
    data = hourly_weather_data(location)
    data.map do |hour|
      OpenStruct.new(time: Time.at(hour[:dt]).strftime('%T'),
                      temperature: hour[:temp],
                      conditions: hour[:weather].first[:description],
                      icon: hour[:weather].first[:icon]
                      ).as_json['table']
    end
  end

  def self.all_weather(location)
    OpenStruct.new(current_weather: current_weather(location),
    daily_weather: daily_weather(location),
    hourly_weather: hourly_weather(location)
    )
  end
end