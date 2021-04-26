require 'rails_helper'

RSpec.describe SalariesFacade do

  describe 'happy path' do
    it 'can request salary data and parse the info' do
      request = SalariesFacade.get_salary_data("denver")
      result = JSON.parse(request.body, symbolize_names: true)

      expect(request.status).to eq(200)
      expect(result[:_links][:self][:href]).to eq("https://api.teleport.org/api/urban_areas/slug:denver/salaries/")
    end

    it 'can get the current weather data' do
      request = SalariesFacade.get_weather_data("denver")

      expect(request).to have_key('datetime')
      expect(request).to have_key('sunrise')
      expect(request).to have_key('sunset')
      expect(request).to have_key('temperature')
      expect(request).to have_key('feels_like')
      expect(request).to have_key('humidity')
      expect(request).to have_key('uvi')
      expect(request).to have_key('visibility')
      expect(request).to have_key('conditions')
      expect(request).to have_key('icon')
    end

    it 'can find the correct jobs' do
      jobs = ["data analyst", 
              "data scientist", 
              "mobile developer", 
              "qa engineer", 
              "software engineer", 
              "systems administrator", 
              "web developer"]
      output = SalariesFacade.correct_jobs("denver")

      incorrect_job = output.find_all do |job|
        !jobs.include?(job[:job][:title].downcase)
      end
      
      expect(incorrect_job.length).to eq(0)
    end

    it 'can format the correct jobs' do
      output = SalariesFacade.format_jobs("denver")

      expect(output.length).to be <= 7

      output.each do |job|
        expect(job).to have_key('title')
        expect(job).to have_key('min')
        expect(job).to have_key('max')
      end
    end
  end
end