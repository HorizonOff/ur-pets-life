module AdminPanel
  module StaticMapHelper
    def generate_static_map_url(location)
      center = "#{location.latitude},#{location.longitude}"
      params = "?size=600x300&zoom=14&markers=color:red%7Clabel:C%7C#{center}&key=#{ENV['GOOGLE_WEB_API_KEY']}"
      'https://maps.googleapis.com/maps/api/staticmap' + params
    end
  end
end
