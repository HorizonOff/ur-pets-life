module AdminPanel
  module StaticMapHelper
    def generate_static_map_url
      "https://maps.googleapis.com/maps/api/staticmap?size=600x300&zoom=14&markers=color:red%7Clabel:C%7C#{@clinic.location.latitude},#{@clinic.location.longitude}&key=#{ENV['GOOGLE_WEB_API_KEY']}"
    end
  end
end
