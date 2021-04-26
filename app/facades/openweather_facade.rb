class OpenweatherFacade

  def self.request_data(latitude, longitude)
    Faraday.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{latitude}&lon=#{longitude}&exclude=minutely,alerts&units=imperial&appid=#{ENV['OPENWEATHER_KEY']}")
  end

  def self.current(latitude, longitude)
    data = JSON.parse(request_data(latitude, longitude).body, symbolize_names: true)[:current]

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

  def self.daily(latitude, longitude)
    response = JSON.parse(request_data(latitude, longitude).body, symbolize_names: true)
    data = response[:daily][0..4]
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

  def self.hourly(latitude, longitude)
    response = JSON.parse(request_data(latitude, longitude).body, symbolize_names: true)
    data = response[:hourly][0..7]
    data.map do |hour|
      OpenStruct.new(time: Time.at(hour[:dt]).strftime('%T'),
                      temperature: hour[:temp],
                      conditions: hour[:weather].first[:description],
                      icon: hour[:weather].first[:icon]
                      ).as_json['table']
    end
  end

  def self.data(latitude, longitude)
    OpenStruct.new(current: current(latitude, longitude),
                  daily: daily(latitude, longitude),
                  hourly: hourly(latitude, longitude)
                  )
  end
end