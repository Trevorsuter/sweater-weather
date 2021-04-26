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

  def self.format_jobs(destination)
    data = find_correct_jobs(destination)
    data.map do |d|
      OpenStruct.new(title: d[:job][:title],
                    min: d[:salary_percentiles][:percentile_25].round(2),
                    max: d[:salary_percentiles][:percentile_75].round(2)
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