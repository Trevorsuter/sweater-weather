class Api::V1::RoadtripController < ApplicationController

  def create
    @user = User.find_by(api_key: params[:api_key])
    if params[:api_key].blank?
      render json: ("You must provide an API key.").to_json, status: 401
    elsif !@user
      render json: ("API key is invalid.").to_json, status: 401
    else
      render json: RoadtripSerializer.new(RoadtripFacade.data(params[:origin], params[:destination]))
    end
  end
end