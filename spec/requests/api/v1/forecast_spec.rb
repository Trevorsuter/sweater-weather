require 'rails_helper'

RSpec.describe 'Forecast API' do

  describe 'happy path' do
    before :each do
      get api_v1_forecast_path, params: { location: 'Denver,CO'}
      # test for location not having a city
      # test for location not having a state
      # test for location not having a comma between city and state

      @result = JSON.parse(response.body, symbolize_names: true)
    end

    it 'has a successful response' do

      expect(response).to be_successful
    end

    xit 'outputs the correct initial keys' do
      expect(@result).to have_key(:data)

      data = @result[:data]

      expect(data).to have_key(:id)
      expect(data).to have_key(:type)
      expect(data).to have_key(:attributes)
    end

    xit 'attributes outputs the correct keys' do
      attributes = @result[:data][:attributes]

      expect(attributes).to have_key(:current_weather)
      expect(attributes).to have_key(:daily_weather)
      expect(attributes).to have_key(:hourly_weather)
    end

    xit 'current weather outputs the right attributes' do
      current_weather = @result[:date][:attributes][:current_weather]

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

    xit 'daily weather outputs 5 days only' do
      daily_weather = @result[:date][:attributes][:daily_weather]

      expect(daily_weather.length).to eq(5)
    end

    xit 'daily weather outputs the right attributes' do
      daily_weather = @result[:date][:attributes][:daily_weather]

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

    xit 'hourly weather outputs 8 hours only' do
      hourly_weather = @result[:date][:attributes][:hourly_weather]

      expect(hourly_weather.length).to eq(8)
    end

    xit 'hourly weather outputs the right attributes' do
      hourly_weather = @result[:date][:attributes][:hourly_weather]

      hourly_weather.each do |hour|
        expect(hour).to have_hey(:time)
        expect(hour).to have_hey(:temperature)
        expect(hour).to have_hey(:conditions)
        expect(hour).to have_hey(:icon)
      end
    end
  end
  
  describe 'sad path' do
  end
end