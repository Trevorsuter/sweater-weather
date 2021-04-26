class MapquestService

  def self.request(location)
    Faraday.get("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_KEY']}&location=#{location}")
  end

  def self.parse_data(location)
    JSON.parse(request(location).body, symbolize_names: true)
  end

  def self.coordinates(location)
    data = parse_data(location)

    latitude = data[:results].first[:locations].first[:latLng][:lat]
    longitude = data[:results].first[:locations].first[:latLng][:lng]

    OpenStruct.new(latitude: latitude, longitude: longitude)
  end
end