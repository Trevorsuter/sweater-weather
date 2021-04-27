require 'rails_helper'

RSpec.describe 'Roadtrip API' do

  describe 'happy path' do
    before :each do
      VCR.use_cassette('roadtrip_API') do
        @user = User.create(email: "example@email.com", password: "password")
  
        headers = { 'CONTENT_TYPE' => 'application/json'}
        body = {
                origin: "Denver,CO",
                destination: "Pueblo,CO",
                api_key: "#{@user.api_key}"
                }.as_json
        
        post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
        @result = JSON.parse(response.body, symbolize_names: true)
      end
    end

    it 'has a successful response' do

      expect(response.status).to eq(200)
    end

    it 'has the correct response body' do

      expect(@result).to have_key(:data)

      expect(@result[:data]).to have_key(:id)
      expect(@result[:data][:id]).to be_nil
      expect(@result[:data]).to have_key(:type)
      expect(@result[:data][:type]).to eq("roadtrip")
      expect(@result[:data]).to have_key(:attributes)

      expect(@result[:data][:attributes]).to have_key(:start_city)
      expect(@result[:data][:attributes][:start_city]).to eq("Denver,CO")
      expect(@result[:data][:attributes]).to have_key(:end_city)
      expect(@result[:data][:attributes][:end_city]).to eq("Pueblo,CO")
      expect(@result[:data][:attributes]).to have_key(:travel_time)
      expect(@result[:data][:attributes][:travel_time]).to eq("01:44:22")
      expect(@result[:data][:attributes]).to have_key(:weather_at_eta)
      expect(@result[:data][:attributes][:weather_at_eta]).to be_a(Hash)

      expect(@result[:data][:attributes][:weather_at_eta]).to have_key(:temperature)
      expect(@result[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
      expect(@result[:data][:attributes][:weather_at_eta]).to have_key(:conditions)
      expect(@result[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
    end
  end

  describe 'sad path' do
    it 'will return an error if no api key is provided' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {
              origin: "Denver,CO",
              destination: "Pueblo,CO"
              }.as_json
      
      post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(result).to eq("You must provide an API key.")
    end

    it 'will return an error if api key is not found' do
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {
              origin: "Denver,CO",
              destination: "Pueblo,CO",
              api_key: "111111"
              }.as_json
      
      post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(result).to eq("API key is invalid.")
    end
  end
end