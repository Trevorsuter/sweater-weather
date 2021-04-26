require 'rails_helper'

RSpec.describe OpenweatherFacade do

  describe 'happy path' do
    before :each do
      @latitude = 39.7385
      @longitude = -104.9849
    end
    it 'can make a successful request' do
      VCR.use_cassette('openweather_facade') do
        request = OpenweatherFacade.request_data(@latitude, @longitude)
        result = JSON.parse(request.body, symbolize_names: true)
  
        expect(request.status).to eq(200)
        expect(result[:lat]).to eq(@latitude)
        expect(result[:lon]).to eq(@longitude)
      end
    end
    
    it 'can create an ostruct for current weather' do
      VCR.use_cassette('openweather_facade') do
        current = OpenweatherFacade.current(@latitude, @longitude)

        expect(current['datetime']).to be_a(String)
        expect(current['sunrise']).to be_a(String)
        expect(current['sunset']).to be_a(String)
        expect(current['temperature']).to be_a(Float)
        expect(current['feels_like']).to be_a(Float)
        expect(current['humidity']).to be_an(Integer)
        expect(current['uvi']).to be_a(Float)
        expect(current['visibility']).to be_an(Integer)
        expect(current['conditions']).to be_a(String)
        expect(current['icon']).to be_a(String)
      end
    end

    it 'can create an ostruct for daily weather' do
      VCR.use_cassette('openweather_facade') do
        daily = OpenweatherFacade.daily(@latitude, @longitude)

        expect(daily.length).to eq(5)

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

    it 'can create an ostruct for hourly weather' do
      VCR.use_cassette('openweather_facade') do
        hourly = OpenweatherFacade.hourly(@latitude, @longitude)

        expect(hourly.length).to eq(8)

        hourly.each do |hour|
          expect(hour['time']).to be_a(String)
          expect(hour['temperature']).to be_a(Float)
          expect(hour['conditions']).to be_a(String)
          expect(hour['icon']).to be_a(String)
        end
      end
    end
  end
end