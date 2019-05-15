class VetTimingWorker
  include Sidekiq::Worker

  def perform(id)
    @vet = Vet.find_by(id: id)
    calendar_generation_service.generate_vet_time_slots
  end

  private

  def calendar_generation_service
    @calendar_generation_service ||= ::CalendarGeneration::BaseService.new(@vet)
  end
end
