module AdminPanel
  module AppointmentsHelper
    def status_class(appointment)
      case appointment.status
      when 'pending'
        'label-warning'
      when 'accepted'
        'label-success'
      else
        'label-danger'
      end
    end
  end
end
