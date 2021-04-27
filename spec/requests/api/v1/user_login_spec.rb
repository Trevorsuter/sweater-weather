require 'rails_helper'

RSpec.describe 'User Login API' do

  describe 'happy path' do
    before :each do
      @user = User.create(email: "example@email.com", password: "password")

      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "#{@user.email}", password: "#{@user.password}"}.as_json

      post api_v1_sessions_path(headers: headers, params: body, as: :json)

      @result = JSON.parse(response.body, symbolize_names: true)
    end

    it 'sends a successful response' do

      expect(response.status).to eq(200)
    end

    it 'outputs the correct data when login is successful' do
      
      expect(@result).to have_key(:data)

      expect(@result[:data]).to have_key(:id)
      expect(@result[:data][:id]).to be_a(String)
      expect(@result[:data][:id].to_i).to eq(@user.id)

      expect(@result[:data]).to have_key(:type)
      expect(@result[:data][:type]).to eq("user")

      expect(@result[:data]).to have_key(:attributes)

      expect(@result[:data][:attributes]).to have_key(:email)
      expect(@result[:data][:attributes][:email]).to eq(@user.email)

      expect(@result[:data][:attributes]).to have_key(:api_key)
      expect(@result[:data][:attributes][:api_key]).to eq(@user.api_key)
    end
  end

  describe 'sad path' do
    it 'wont login without the correct password' do
      @user = User.create(email: "example@email.com", password: "password")

      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "#{@user.email}", password: "some_other_password"}.as_json

      post api_v1_sessions_path(headers: headers, params: body, as: :json)

      @result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(@result).to eq("Incorrect login.")
    end

    it 'wont login without a email provided' do
      @user = User.create(email: "example@email.com", password: "password")

      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {password: "#{@user.password}"}.as_json

      post api_v1_sessions_path(headers: headers, params: body, as: :json)

      @result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(@result).to eq("Incorrect login.")
    end

    it 'wont login without a password provided' do
      @user = User.create(email: "example@email.com", password: "password")

      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {email: "#{@user.email}"}.as_json

      post api_v1_sessions_path(headers: headers, params: body, as: :json)

      @result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(@result).to eq("Incorrect login.")
    end
  end
end