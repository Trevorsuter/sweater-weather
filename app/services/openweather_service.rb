class OpenweatherService

  def self.get_data(latitude, longitude)
    Faraday.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{latitude}&lon=#{longitude}&exclude=minutely,alerts&units=imperial&appid=#{ENV['OPENWEATHER_KEY']}")
  end

  def self.parse_data(latitude, longitude)
    JSON.parse(get_data(latitude, longitude).body, symbolize_names: true)
  end

  def self.current_weather_data(latitude, longitude)
    parse_data(latitude, longitude)[:current]
  end

  def self.daily_weather_data(latitude, longitude)
    parse_data(latitude, longitude)[:daily][0..4]
  end

  def self.hourly_weather_data(latitude, longitude)
    parse_data(latitude, longitude)[:hourly][0..7]
  end

  def self.current_weather(latitude, longitude)
    data = current_weather_data(latitude, longitude)
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

  def self.daily_weather(latitude, longitude)
    data = daily_weather_data(latitude, longitude)

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

  def self.hourly_weather(latitude, longitude)
    data = hourly_weather_data(latitude, longitude)
    data.map do |hour|
      OpenStruct.new(time: Time.at(hour[:dt]).strftime('%T'),
                      temperature: hour[:temp],
                      conditions: hour[:weather].first[:description],
                      icon: hour[:weather].first[:icon]
                      ).as_json['table']
    end
  end

  def self.all_weather(latitude, longitude)
    OpenStruct.new(current_weather: current_weather(latitude, longitude),
    daily_weather: daily_weather(latitude, longitude),
    hourly_weather: hourly_weather(latitude, longitude)
    )
  end
end