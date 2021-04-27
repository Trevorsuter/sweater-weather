class Api::V1::RoadtripController < ApplicationController

  def create
    @user = User.find_by(api_key: params[:api_key])
    if params[:api_key].blank?
      render json: ("You must provide an API key.").to_json, status: 401
    elsif !@user
      render json: ("API key is invalid.").to_json, status: 401
    else
      trip_connection = Faraday.get("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_KEY']}&from=#{params[:origin]}&to=#{params[:destination]}")
      parsed = JSON.parse(trip_connection.body, symbolize_names: true)
      route = parsed[:route]
      travel_time = route[:formattedTime]
      travel_time_in_seconds = route[:time]
      start_time = Time.now
      end_time = start_time + travel_time_in_seconds
      endpoint_latitude = route[:locations].last[:displayLatLng][:lat]
      endpoint_longitude = route[:locations].last[:displayLatLng][:lng]
      weather_connection = OpenweatherService.parse_data(endpoint_latitude, endpoint_longitude)
      if travel_time_in_seconds >= 172800
        weather_data = weather_connection[:daily].select do |day|
          Time.at(day[:dt]).day == end_time.day
        end
      else travel_time_in_seconds <= 172800
        weather_data = weather_connection[:hourly].select do |hour|
          (Time.at(hour[:dt]).hour == end_time.hour) && (Time.at(hour[:dt]).day == end_time.day)
        end.first
      end
      endpoint_temp = weather_data[:temp]
      endpoint_conditions = weather_data[:weather].first[:description]
      render json: RoadtripSerializer.new(formatted_output(travel_time, endpoint_temp, endpoint_conditions))
    end
  end

  def formatted_output(travel_time, temperature, conditions)
    OpenStruct.new(start_city: params[:origin],
                end_city: params[:destination],
                travel_time: travel_time,
                weather_at_eta: {
                  temperature: temperature,
                  conditions: conditions
                }
                )
  end
end