require 'rails_helper'

RSpec.describe OpenweatherService do
  describe 'happy path' do
    before :each do
      @latitude = 39.738453
      @longitude = -104.984853
    end
    it 'can make a successful request' do
      VCR.use_cassette('openweather_service') do
        request = OpenweatherService.get_data(@latitude, @longitude)

        expect(request.status).to eq(200)
      end
    end

    it 'can separate the current, daily, and hourly weather data' do
      VCR.use_cassette('openweather_service_compare') do
        all_data = JSON.parse(OpenweatherService.get_data(@latitude, @longitude).body, symbolize_names: true)
        current_data = OpenweatherService.current_weather_data(@latitude, @longitude)
        hourly_data = OpenweatherService.hourly_weather_data(@latitude, @longitude)
        daily_data = OpenweatherService.daily_weather_data(@latitude, @longitude)

        expect(all_data[:current]).to eq(current_data)
        expect(all_data[:daily][0..4]).to eq(daily_data)
        expect(all_data[:hourly][0..7]).to eq(hourly_data)
      end
    end

    it 'can format current weather correctly' do
      VCR.use_cassette('openweather_service') do
        current = OpenweatherService.current_weather(@latitude, @longitude)
  
        expect(current).to be_a(Hash)
        expect(current['datetime']).to be_a(String)
        expect(current['sunrise']).to be_a(String)
        expect(current['sunset']).to be_a(String)
        expect(current['temperature']).to be_a(Float)
        expect(current['feels_like']).to be_a(Float)
        expect(current['humidity']).to be_an(Integer)
        expect(current['uvi']).to_not be_a(String)
        expect(current['visibility']).to be_an(Integer)
        expect(current['conditions']).to be_a(String)
        expect(current['icon']).to be_a(String)
      end
    end

    it 'only gives 5 days of daily weather' do
      VCR.use_cassette('openweather_service') do
        daily = OpenweatherService.daily_weather_data(@latitude, @longitude)

        expect(daily.length).to eq(5)
      end
    end

    it 'can format daily weather correctly' do
      VCR.use_cassette('openweather_service') do
        daily = OpenweatherService.daily_weather(@latitude, @longitude)

        daily.each do |day|
          expect(day['date']).to be_a(String)
          expect(day['sunrise']).to be_a(String)
          expect(day['sunset']).to be_a(String)
          expect(day['max_temp']).to be_a(Float)
          expect(day['min_temp']).to be_a(Float)
          expect(day['conditions']).to be_a(String)
          expect(day['icon']).to be_a(String)
        end
      end
    end

    it 'only gives 8 hours of hourly weather data' do
      VCR.use_cassette('openweather_service') do
        hourly = OpenweatherService.hourly_weather_data(@latitude, @longitude)

        expect(hourly.length).to eq(8)
      end
    end

    it 'can format hourly weather correctly' do
      VCR.use_cassette('openweather_service') do
        hourly = OpenweatherService.hourly_weather(@latitude, @longitude)

        hourly.each do |hour|
          expect(hour['time']).to be_a(String)
          expect(hour['temperature']).to be_a(Float)
          expect(hour['conditions']).to be_a(String)
          expect(hour['icon']).to be_a(String)
        end
      end
    end

    it 'can combine all three versions of weather data into one ostruct' do
      VCR.use_cassette('openweather_service_all') do
        data = OpenweatherService.all_weather(@latitude, @longitude)

        expect(data.current_weather).to have_key('datetime')
        expect(data.current_weather).to have_key('sunrise')
        expect(data.current_weather).to have_key('sunset')
        expect(data.current_weather).to have_key('temperature')
        expect(data.current_weather).to have_key('feels_like')
        expect(data.current_weather).to have_key('humidity')
        expect(data.current_weather).to have_key('uvi')
        expect(data.current_weather).to have_key('visibility')
        expect(data.current_weather).to have_key('conditions')
        expect(data.current_weather).to have_key('icon')

        data.daily_weather.each do |day|
          expect(day).to have_key('date')
          expect(day).to have_key('sunrise')
          expect(day).to have_key('sunset')
          expect(day).to have_key('max_temp')
          expect(day).to have_key('min_temp')
          expect(day).to have_key('conditions')
          expect(day).to have_key('icon')
        end
        
        data.hourly_weather.each do |hour|
          expect(hour).to have_key('time')
          expect(hour).to have_key('temperature')
          expect(hour).to have_key('conditions')
          expect(hour).to have_key('icon')
        end
      end
    end
  end
end