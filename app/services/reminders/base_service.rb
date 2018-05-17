module Reminders
  class BaseService
    def initialize(pet, current_date)
      @pet = pet
      @vaccine_types = pet.vaccine_types
      @vaccinations = pet.vaccinations
      @user = pet.user
      @current_date = current_date
    end

    def generate_notifications
      vaccine_types.each do |vaccine_type|
        next if pet_vaccine_types[vaccine_type.name].blank?
        select_vaccinations(vaccine_type)
        choose_vaccine_rule(vaccine_type)
      end
    end

    private

    attr_reader :pet, :vaccine_types, :vaccinations, :user, :current_date

    def select_vaccinations(vaccine_type)
      @selected_vaccinations = vaccinations.select { |v| v.vaccine_type_id == vaccine_type.id }
    end

    def choose_vaccine_rule(vaccine_type)
      if @selected_vaccinations.size.zero?
        use_fixed_intervals = true
        count_planned_vacinnation_date(vaccine_type, use_fixed_intervals)
      elsif @selected_vaccinations.size >= fixed_time_intervals(vaccine_type).size
        count_planned_vacinnation_date(vaccine_type)
      else
        check_fixed_time_ranges(vaccine_type)
      end
    end

    def count_planned_vacinnation_date(vaccine_type, use_fixed_intervals = false)
      set_starting_point
      planned_date = lead_to_current_time(vaccine_type, use_fixed_intervals)
      create_notification(vaccine_type) if its_time_for_vaccination?(planned_date)
    end

    def set_starting_point
      @starting_point = @selected_vaccinations.present? ? last_vaccination_date : pet.birthday.to_date
    end

    def last_vaccination_date
      @selected_vaccinations.first.done_at.to_date
    end

    def lead_to_current_time(vaccine_type, use_fixed_intervals)
      planned_date = @starting_point
      if use_fixed_intervals
        planned_date = add_fixed_intervals(vaccine_type, planned_date)
        return lead_to_current_time_with_recurring_interval(vaccine_type, planned_date) if current_date > planned_date
        planned_date
      else
        lead_to_current_time_with_recurring_interval(vaccine_type, planned_date)
      end
    end

    def add_fixed_intervals(vaccine_type, planned_date)
      fixed_time_intervals(vaccine_type).each do |interval|
        planned_date += interval
        break if current_date <= planned_date
      end
      planned_date
    end

    def fixed_time_intervals(vaccine_type)
      pet_vaccine_types[vaccine_type.name][:fixed_time_intervals]
    end

    def lead_to_current_time_with_recurring_interval(vaccine_type, planned_date)
      interval = pet_vaccine_types[vaccine_type.name][:recurring_time_interval]
      loop do
        planned_date += interval
        break planned_date if current_date <= planned_date
      end
    end

    def its_time_for_vaccination?(planned_date)
      current_date == planned_date
    end

    def create_notification(vaccine_type)
      message = "Don't forget to make vaccination #{vaccine_type.name} for your pet #{pet.name}"
      user.notifications.create(pet: pet, is_for_vaccine: true, message: message)
    end

    def check_fixed_time_ranges(vaccine_type)
      planned_prelast_fixed_vaccination_date = (pet.birthday + fixed_time_intervals(vaccine_type).sum).to_date - 1.day
      if last_vaccination_date > planned_prelast_fixed_vaccination_date
        count_planned_vacinnation_date(vaccine_type)
      else
        count_planned_vacinnation_fixed_date(vaccine_type)
      end
    end

    def count_planned_vacinnation_fixed_date(vaccine_type)
      planned_date = last_vaccination_date + fixed_time_intervals(vaccine_type).last
      planned_date = lead_to_current_time_with_recurring_interval(vaccine_type, planned_date) \
        if current_date > planned_date
      create_notification(vaccine_type) if its_time_for_vaccination?(planned_date)
    end
  end
end
