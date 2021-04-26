class Api::V1::BackgroundsController < ApplicationController

  def index
    image = BackgroundsFacade.formatted_image(params[:location])
    render json: BackgroundsSerializer.new(image)
  end
end