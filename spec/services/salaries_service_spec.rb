require 'rails_helper'

RSpec.describe SalariesService do

  describe 'happy path' do
    it 'can request salary data and parse the info' do
      request = SalariesService.get_data("denver")
      result = JSON.parse(request.body, symbolize_names: true)

      expect(request.status).to eq(200)
      expect(result[:_links][:self][:href]).to eq("https://api.teleport.org/api/urban_areas/slug:denver/salaries/")
    end

    it 'can parse the data' do
      data = SalariesService.parse_data("denver")

      expect(data).to be_a(Hash)
      expect(data).to have_key(:salaries)
      expect(data[:salaries]).to be_an(Array)
    end

    it 'can find the correct jobs' do
      jobs = ["data analyst", 
      "data scientist", 
      "mobile developer", 
      "qa engineer", 
      "software engineer", 
      "systems administrator", 
      "web developer"]
      output = SalariesService.find_correct_jobs("denver")
      
      incorrect_job = output.find_all do |job|
        !jobs.include?(job[:job][:title].downcase)
      end
      
      expect(incorrect_job.length).to eq(0)
    end
  end
end