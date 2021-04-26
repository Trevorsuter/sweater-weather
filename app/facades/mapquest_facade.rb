class MapquestFacade
  
  def self.get_coordinates(location)
    request = MapquestService.parse_data(location)
    latitude = request[:results].first[:locations].first[:latLng][:lat]
    longitude = request[:results].first[:locations].first[:latLng][:lng]

    OpenStruct.new(latitude: latitude, longitude: longitude)
  end
end