namespace :appointment_reminders do
  desc 'Sending reminders about appointment'

  task clinics: :environment do
    ::AppointmentServices::AppointmentReminderService.new('Clinic').send_reminder
  end
  task grooming_centres: :environment do
    ::AppointmentServices::AppointmentReminderService.new('GroomingCentre').send_reminder
  end
  task day_care_centres: :environment do
    ::AppointmentServices::AppointmentReminderService.new('DayCareCentre').send_reminder
  end
  task boardings: :environment do
    ::AppointmentServices::AppointmentReminderService.new('Boarding').send_reminder
  end
end 
