class Api::V1::SessionsController < ApplicationController

  def create
    @user = User.find_by(email: params[:email])

    if !@user || !@user.authenticate(params[:password])
      render json: ("Incorrect login.").to_json, status: 401
    else @user.authenticate(params[:password])
      render json: UserSerializer.new(@user), status: 200
    end
  end
end