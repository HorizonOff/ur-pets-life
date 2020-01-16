namespace :update_name do
  desc 'Update name of user locations'
  task user_locations: :environment do
    Location.where(place_type: 'User').each do |location|
      location.update_columns(name: 'Home')
    end
  end
end
