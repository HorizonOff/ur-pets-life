namespace :past_appointments do
  desc 'Cancel past appointments'
  task clinic_cancellation: :environment do
    ::AppointmentServices::PastAppointmentsCancelationService.new('Clinic').cancel_appointments
  end
  task grooming_cancellation: :environment do
    ::AppointmentServices::PastAppointmentsCancelationService.new('GroomingCentre').cancel_appointments
  end
  task day_care_cancellation: :environment do
    ::AppointmentServices::PastAppointmentsCancelationService.new('DayCareCentre').cancel_without_notification
  end
  task boarding_cancellation: :environment do
    ::AppointmentServices::PastAppointmentsCancelationService.new('Boarding').cancel_without_notification
  end
end
