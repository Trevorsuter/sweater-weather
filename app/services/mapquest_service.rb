class MapquestService

  def self.request(location)
    Faraday.get("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_KEY']}&location=#{location}")
  end

  def self.parse_data(location)
    JSON.parse(request(location).body, symbolize_names: true)
  end
end