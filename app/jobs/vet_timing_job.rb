class VetTimingJob
  include SuckerPunch::Job

  def perform(id)
    ActiveRecord::Base.connection_pool.with_connection do
      @vet = Vet.find_by(id: id)
      calendar_generation_service.generate_vet_time_slots
    end
  end

  private

  def calendar_generation_service
    @calendar_generation_service ||= ::CalendarGeneration::BaseService.new(@vet)
  end
end
