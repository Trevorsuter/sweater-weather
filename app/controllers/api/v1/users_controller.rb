class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if params[:email].blank? || params[:password].blank? || params[:password_confirmation].blank?
      render json: ("You forgot some fields.").to_json, status: 401
    elsif params[:password] != params[:password_confirmation]
      render json: ("Your passwords don't match.").to_json, status: 401
    elsif !@user.save
    render json: ("User Exists.").to_json, status: 401
    else @user.save
      render json: UserSerializer.new(@user), status: 201
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end