class Api::V1::RoadtripController < ApplicationController

  def create
    @user = User.find_by(api_key: params[:api_key])
    if params[:api_key].blank?
      render json: ("You must provide an API key.").to_json, status: 401
    elsif !@user
      render json: ("API key is invalid.").to_json, status: 401
    elsif bad_trip
      render json: bad_trip.to_json, status: 401
    else
      render json: RoadtripSerializer.new(RoadtripFacade.data(params[:origin], params[:destination]))
    end
  end

  private

  def bad_trip
    response = RoadtripFacade.bad_trip(params[:origin], params[:destination])
    return "We had an error with one of your given locations. Try being more specific, or using the nearest city." if response == "Unable to use location #1 :Must have a valid GEFID."
    return "This trip is impossible, unless your ride is super duper special..." if response == ("We are unable to route with the given locations." || "Unable to calculate route.")
  end
end