module AdminPanel
  class AppointmentCalendarSerializer < BaseMethodsSerializer
    attributes :id, :start, :end, :url
    attribute :appointment do
      true
    end

    def start
      object.start_at
    end

    def end
      object.end_at
    end

    def url
      '/admin_panel/appointments/' + object.id.to_s
    end
  end
end
