require 'rails_helper'

RSpec.describe SalariesFacade do

  describe 'happy path' do
    it 'can request salary data and parse the info' do
      request = SalariesFacade.get_salary_data("denver")
      result = JSON.parse(request.body, symbolize_names: true)

      expect(request.status).to eq(200)
      expect(result[:_links][:self][:href]).to eq("https://api.teleport.org/api/urban_areas/slug:denver/salaries/")
    end
  end
end