class SalariesFacade

  def self.get_salary_data(destination)
    Faraday.get("https://api.teleport.org/api/urban_areas/slug:#{destination}/salaries")
  end

  def self.get_weather_data(destination)
    coordinates = MapquestFacade.get_coordinates(destination)
    OpenweatherFacade.current(coordinates.latitude, coordinates.longitude)
  end

  def self.correct_jobs(destination)
    data = get_salary_data(destination)
    parsed = JSON.parse(data.body, symbolize_names: true)
    
    parsed[:salaries].find_all do |correct_jobs|
      allowed_jobs.include?(correct_jobs[:job][:title].downcase)
    end
  end

  def self.format_jobs(destination)
    data = correct_jobs(destination)
    data.map do |d|
      OpenStruct.new(title: d[:job][:title],
                    min: d[:salary_percentiles][:percentile_25],
                    max: d[:salary_percentiles][:percentile_75]
                    ).as_json['table']
    end
  end

  def self.allowed_jobs
    ["data analyst", 
    "data scientist", 
    "mobile developer", 
    "qa engineer", 
    "software engineer", 
    "systems administrator", 
    "web developer"]
  end
end