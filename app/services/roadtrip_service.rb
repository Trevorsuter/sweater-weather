class RoadtripService

  def self.get_data(origin, destination)
    Faraday.get("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_KEY']}&from=#{origin}&to=#{destination}")
  end

  def self.parsed_data(origin, destination)
    JSON.parse(get_data(origin, destination).body, symbolize_names: true)
  end

  def self.data(origin, destination)
    route = parsed_data(origin, destination)[:route]
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
end