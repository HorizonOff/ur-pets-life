namespace :counter_cache do
  desc 'Resseting comments counters in posts and appointments'

  task reset_posts_counters: :environment do
    Post.reset_column_information
    Post.with_deleted.pluck(:id).each do |id|
      Post.reset_counters(id, :comments)
    end
  end

  task reset_appointments_counters: :environment do
    Appointment.reset_column_information
    Appointment.with_deleted.pluck(:id).each do |id|
      Appointment.reset_counters(id, :comments)
    end
  end
end
