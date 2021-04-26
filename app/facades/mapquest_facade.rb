class MapquestFacade
  def self.request_location(location)
    Faraday.get("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_KEY']}&location=#{location}")
  end

  def self.get_coordinates(location)
    request = JSON.parse(request_location(location).body, symbolize_names: true)
    latitude = request[:results].first[:locations].first[:latLng][:lat]
    longitude = request[:results].first[:locations].first[:latLng][:lng]

    OpenStruct.new(latitude: latitude, longitude: longitude)
  end
end