class BackgroundsService

  def self.format_query(location)
    location.gsub(",", "+")
  end

  def self.get_data(location)
  Faraday.get("https://api.bing.microsoft.com/v7.0/images/search?q=#{format_query(location)}+downtown") do |conn|
      conn.headers['Ocp-Apim-Subscription-Key'] = ENV['BING_IMAGE_SEARCH_KEY']
    end
  end

  def self.first_image(location)
    parsed = JSON.parse(get_data(location).body, symbolize_names: true)
    parsed[:value].first
  end

  def self.image(location)
    image = first_image(location)
    OpenStruct.new(location: location,
                  search_url: image[:webSearchUrl],
                  image_url: image[:contentUrl],
                  credit: {name: image[:name],
                  source: image[:hostPageUrl],
                  logo: image[:hostPageFavIconUrl]}
                  ).as_json['table']
  end
end