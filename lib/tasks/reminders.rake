namespace :reminders do
  desc 'Sending reminders for pet vaccinations'
  task daily_generation: :environment do
    current_date = Date.current
    Pet.joins(:pet_type).where(pet_types: { is_additional_type: false }).owned
       .includes(:user, :vaccinations, :pet_type, pet_type: :vaccine_types).each do |pet|
      if pet.pet_type.name == 'Cat'
        ::Reminders::CatVaccinationsService.new(pet, current_date).generate_notifications
      elsif pet.pet_type.name == 'Dog'
        ::Reminders::DogVaccinationsService.new(pet, current_date).generate_notifications
      end
    end
  end
end
