class BackgroundsFacade

  def self.formatted_image(location)
    OpenStruct.new(image: BackgroundsService.image(location))
  end

end