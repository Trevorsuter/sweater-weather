class SalariesService

  def self.get_data(destination)
    Faraday.get("https://api.teleport.org/api/urban_areas/slug:#{destination}/salaries")
  end

  def self.parse_data(destination)
    JSON.parse(get_data(destination).body, symbolize_names: true)
  end

  def self.find_correct_jobs(destination)
    data = parse_data(destination)

    data[:salaries].find_all do |correct_jobs|
      allowed_jobs.include?(correct_jobs[:job][:title].downcase)
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