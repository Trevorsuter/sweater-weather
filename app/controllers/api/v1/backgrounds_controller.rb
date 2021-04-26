class Api::V1::BackgroundsController < ApplicationController

  def index
    location = params[:location].gsub!(",", "+")
    request = Faraday.get("https://api.bing.microsoft.com/v7.0/images/search?q=#{location}+skyline") do |conn|
      conn.headers['Ocp-Apim-Subscription-Key'] = ENV['BING_IMAGE_SEARCH_KEY']
    end
    
    render json: {}
  end
end