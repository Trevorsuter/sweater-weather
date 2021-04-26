class Api::V1::SalariesController < ApplicationController

  def index
    render json: SalariesSerializer.new(SalariesFacade.generate_combined_data(params[:destination]))
  end
end