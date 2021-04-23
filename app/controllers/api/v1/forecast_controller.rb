class Api::V1::ForecastController < ApplicationController
  def index
    mapquest = Faraday.get("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_KEY']}&location=#{params[:location]}")
    location_result = JSON.parse(mapquest.body, symbolize_names: true)
    latitude = location_result[:results].first[:locations].first[:latLng][:lat]
    longitude = location_result[:results].first[:locations].first[:latLng][:lng]

    openweather = Faraday.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{latitude}&lon=#{longitude}&exclude=minutely,alerts&units=imperial&appid=#{ENV['OPENWEATHER_KEY']}")
    weather_result = JSON.parse(openweather.body, symbolize_names: true)
    current = weather_result[:current]
    daily = weather_result[:daily][0..4]
    hourly = weather_result[:hourly][0..7]

    formatted_current = format_current(current)
    formatted_daily = format_daily(daily)
    formatted_hourly = format_hourly(hourly)

    render json: forecast_output(formatted_current, formatted_daily, formatted_hourly)
  end

  private

  def forecast_output(current, daily, hourly)
    output = {data: {
        id: nil,
        type: "forecast",
        attributes: {
          current_weather: current,
          daily_weather: daily,
          hourly_weather: hourly
          }
        }
      }
    output.to_json
  end

  def format_current(data)
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

  def format_daily(data)
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

  def format_hourly(data)
    data.map do |hour|
      OpenStruct.new(time: Time.at(hour[:dt]).strftime('%T'),
                      temperature: hour[:temp],
                      conditions: hour[:weather].first[:description],
                      icon: hour[:weather].first[:icon]
                      ).as_json['table']
    end
  end
end