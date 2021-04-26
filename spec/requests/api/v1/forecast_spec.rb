require 'rails_helper'

RSpec.describe 'Forecast API' do

  describe 'happy path' do
    before :each do
      VCR.use_cassette('forecast_api') do
        get api_v1_forecast_path(location: 'denver,co')
      # test for location not having a city
      # test for location not having a state
      # test for location not having a comma between city and state

        @result = JSON.parse(response.body, symbolize_names: true)
      end
    end

    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'outputs the correct initial keys' do
      expect(@result).to have_key(:data)

      data = @result[:data]

      expect(data).to have_key(:id)
      expect(data).to have_key(:type)
      expect(data).to have_key(:attributes)
    end

    it 'attributes outputs the correct keys' do
      attributes = @result[:data][:attributes]

      expect(attributes).to have_key(:current_weather)
      expect(attributes).to have_key(:daily_weather)
      expect(attributes).to have_key(:hourly_weather)
    end

    it 'current weather outputs the right attributes' do
      current_weather = @result[:data][:attributes][:current_weather]

      expect(current_weather).to have_key(:datetime)
      expect(current_weather).to have_key(:sunrise)
      expect(current_weather).to have_key(:sunset)
      expect(current_weather).to have_key(:temperature)
      expect(current_weather).to have_key(:feels_like)
      expect(current_weather).to have_key(:humidity)
      expect(current_weather).to have_key(:uvi)
      expect(current_weather).to have_key(:visibility)
      expect(current_weather).to have_key(:conditions)
      expect(current_weather).to have_key(:icon)
    end

    it 'daily weather outputs 5 days only' do
      daily_weather = @result[:data][:attributes][:daily_weather]

      expect(daily_weather.length).to eq(5)
    end

    it 'daily weather outputs the right attributes' do
      daily_weather = @result[:data][:attributes][:daily_weather]

      daily_weather.each do |day|
        expect(day).to have_key(:date)
        expect(day).to have_key(:sunrise)
        expect(day).to have_key(:sunset)
        expect(day).to have_key(:max_temp)
        expect(day).to have_key(:min_temp)
        expect(day).to have_key(:conditions)
        expect(day).to have_key(:icon)
      end
    end

    it 'hourly weather outputs 8 hours only' do
      hourly_weather = @result[:data][:attributes][:hourly_weather]

      expect(hourly_weather.length).to eq(8)
    end

    it 'hourly weather outputs the right attributes' do
      hourly_weather = @result[:data][:attributes][:hourly_weather]

      hourly_weather.each do |hour|
        expect(hour).to have_key(:time)
        expect(hour).to have_key(:temperature)
        expect(hour).to have_key(:conditions)
        expect(hour).to have_key(:icon)
      end
    end
  end
  
  describe 'sad path' do
  end
end