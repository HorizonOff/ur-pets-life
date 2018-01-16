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

    def appointment_actions(appointment, btn_class = '')
      if appointment.pending?
        link_for_accepting(appointment, btn_class) + link_for_rejecting(appointment, btn_class)
      elsif appointment.accepted?
        link_for_rejecting(appointment, btn_class)
      else
        link_for_accepting(appointment, btn_class)
      end
    end

    def link_for_accepting(appointment, btn_class)
      link_to accept_admin_panel_appointment_path(appointment), class: "btn btn-success #{btn_class}", method: :put do
        content_tag(:i, nil, class: 'fa fa-check') + 'Accept'
      end
    end

    def link_for_rejecting(appointment, btn_class)
      link_to reject_admin_panel_appointment_path(appointment), class: "btn btn-danger #{btn_class}", method: :put do
        content_tag(:i, nil, class: 'fa fa-close') + 'Reject'
      end
    end
  end
end
