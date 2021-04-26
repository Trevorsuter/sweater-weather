class Api::V1::BackgroundsController < ApplicationController

  def index
    location = params[:location].gsub!(",", "+")
    request = Faraday.get("https://api.bing.microsoft.com/v7.0/images/search?q=#{location}+downtown") do |conn|
      conn.headers['Ocp-Apim-Subscription-Key'] = ENV['BING_IMAGE_SEARCH_KEY']
    end
    parsed = JSON.parse(request.body, symbolize_names: true)
    image = parsed[:value].first
    formatted_image = formatted_image(image)

    render json: formatted_output(formatted_image)
  end

  def formatted_output(image)
    output = { data: {
                type: "image",
                id: nil,
                attributes: {
                  image: image
                }
              }

    }
    output.to_json
  end

  def formatted_image(data)
    credits = OpenStruct.new(name: data[:name],
                            source: data[:hostPageUrl],
                            logo: data[:hostPageFavIconUrl]
                            ).as_json['table']
    OpenStruct.new(location: params[:location].gsub("+", ","),
                  search_url: data[:webSearchUrl],
                  image_url: data[:contentUrl],
                  credit: credits
                  ).as_json['table']
  end
end