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
        expect(current['uvi']).to be_an(Integer)
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

    it 'can combine all of the info' do
      VCR.use_cassette('combine_openweather_facade') do
        data = OpenweatherFacade.data(@latitude, @longitude)

        expect(data.current).to have_key('datetime')
        expect(data.current).to have_key('sunrise')
        expect(data.current).to have_key('sunset')
        expect(data.current).to have_key('temperature')
        expect(data.current).to have_key('feels_like')
        expect(data.current).to have_key('humidity')
        expect(data.current).to have_key('uvi')
        expect(data.current).to have_key('visibility')
        expect(data.current).to have_key('conditions')
        expect(data.current).to have_key('icon')

        data.daily.each do |day|
          expect(day).to have_key('date')
          expect(day).to have_key('sunrise')
          expect(day).to have_key('sunset')
          expect(day).to have_key('max_temp')
          expect(day).to have_key('min_temp')
          expect(day).to have_key('conditions')
          expect(day).to have_key('icon')
        end
        
        data.hourly.each do |hour|
          expect(hour).to have_key('time')
          expect(hour).to have_key('temperature')
          expect(hour).to have_key('conditions')
          expect(hour).to have_key('icon')
        end
      end
    end
  end
end