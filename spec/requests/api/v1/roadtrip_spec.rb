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
      expect(result).to eq("You're missing some parameters.")
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

    it 'will return an error if the trip is impossible' do
      VCR.use_cassette('bad_trip') do
        user = User.create(email: "example@email.com", password: "password")
    
        headers = { 'CONTENT_TYPE' => 'application/json'}
        body = {
                origin: "Denver,CO",
                destination: "London, UK",
                api_key: "#{user.api_key}"
                }.as_json
        
        post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
        result = JSON.parse(response.body)

        expect(result).to eq("This trip is impossible, unless your ride is super duper special...")
        expect(response.status).to eq(401)
      end
    end

    it 'will return an error if mapquest cant read the destinations correctly' do
      VCR.use_cassette('bad_trip_2') do
        user = User.create(email: "example@email.com", password: "password")
    
        headers = { 'CONTENT_TYPE' => 'application/json'}
        body = {
                origin: "Denver,CO",
                destination: "Alaska,US",
                api_key: "#{user.api_key}"
                }.as_json
        
        post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
        result = JSON.parse(response.body)

        expect(result).to eq("We had an error with one of your given locations. Try being more specific, or using the nearest city.")
        expect(response.status).to eq(401)
      end
    end

    it 'will return an error if origin is not given' do
      user = User.create(email: "example@email.com", password: "password")
    
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {
              destination: "London, UK",
              api_key: "#{user.api_key}"
              }.as_json
      
      post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
      result = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(result).to eq("You're missing some parameters.")
    end

    it 'will return an error if destination is not given' do
      user = User.create(email: "example@email.com", password: "password")
    
      headers = { 'CONTENT_TYPE' => 'application/json'}
      body = {
              origin: "London, UK",
              api_key: "#{user.api_key}"
              }.as_json
      
      post api_v1_roadtrip_path(headers: headers, params: body, as: :json)
      result = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(result).to eq("You're missing some parameters.")

    end
  end
end