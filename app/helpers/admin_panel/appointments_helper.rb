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

    def appointment_actions(appointment)
      if appointment.pending?
        accept_reject_links(appointment)
      elsif appointment.accepted?
        link_for_canceling(appointment)
      end
    end

    private

    def accept_reject_links(appointment)
      if appointment.can_be_accepted?
        (link_for_accepting(appointment) + link_for_rejecting(appointment))
      else
        link_for_rejecting(appointment)
      end
    end

    def link_for_accepting(appointment)
      link_to accept_admin_panel_appointment_path(appointment), class: 'btn btn-success', method: :put do
        content_tag(:i, nil, class: 'fa fa-check') + 'Accept'
      end
    end

    def link_for_rejecting(appointment)
      link_to reject_admin_panel_appointment_path(appointment), class: 'btn btn-danger', method: :put do
        content_tag(:i, nil, class: 'fa fa-close') + 'Reject'
      end
    end

    def link_for_canceling(appointment)
      link_to cancel_admin_panel_appointment_path(appointment), class: 'btn btn-danger', method: :put do
        content_tag(:i, nil, class: 'fa fa-close') + 'Cancel'
      end
    end
  end
end
