class BackgroundsFacade

  def self.format_params(location)
    location.gsub(",", "+")
  end

  def self.get_backgrounds(location)
    Faraday.get("https://api.bing.microsoft.com/v7.0/images/search?q=#{format_params(location)}+downtown") do |conn|
      conn.headers['Ocp-Apim-Subscription-Key'] = ENV['BING_IMAGE_SEARCH_KEY']
    end
  end

  def self.first_image(location)
    parsed = JSON.parse(get_backgrounds(location).body, symbolize_names: true)
    parsed[:value].first
  end

end