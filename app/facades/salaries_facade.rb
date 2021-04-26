class SalariesFacade

  def self.get_salary_data(destination)
    Faraday.get("https://api.teleport.org/api/urban_areas/slug:#{destination}/salaries")
  end
end