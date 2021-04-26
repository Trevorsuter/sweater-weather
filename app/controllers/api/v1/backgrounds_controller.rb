class Api::V1::BackgroundsController < ApplicationController

  def index
    image = BackgroundsFacade.first_image(params[:location])
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
    OpenStruct.new(location: params[:location],
                  search_url: data[:webSearchUrl],
                  image_url: data[:contentUrl],
                  credit: {name: data[:name],
                  source: data[:hostPageUrl],
                  logo: data[:hostPageFavIconUrl]}
                  ).as_json['table']
  end
end