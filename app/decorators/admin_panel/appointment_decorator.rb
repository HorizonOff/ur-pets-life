module AdminPanel
  class AppointmentDecorator < ApplicationDecorator
    decorates :appointment
    delegate_all

    attr_accessor :output_buffer

    def user_name
      model.unread_comments_count_by_admin.zero? ? model.user.name : model.user.name + comments_icon
    end
  
    def status_label
      text = model.status.humanize
      content = content_tag(:span, text, class: "label #{status_class}")
      unless model.is_viewed?
        content += ' '
        content += content_tag(:span, 'New', class: 'label label-primary')
      end
      content
    end

    def actions
      (link_to 'Show', url_helpers.admin_panel_appointment_path(model), class: 'btn btn-primary btn-xs') +
        status_actions
    end

    def booked_object
      content_tag(:a, model.bookable.name) + content_tag(:br) + content_tag(:small, model.bookable_type)
    end

    def vet_name
      model.vet.try(:name)
    end

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def start_at
      model.start_at.strftime('%-d %b %Y %I:%M %p')
    end

    private

    def comments_icon
      content_tag(
        :span, model.unread_comments_count_by_admin, class: 'fa fa-comment pull-right', style: 'color:orange;'
      )
    end

    def status_class
      case model.status
      when 'pending'
        'label-warning'
      when 'accepted'
        'label-success'
      else
        'label-danger'
      end
    end

    def status_actions
      if model.pending?
        model.can_be_accepted? ? (link_for_accepting + link_for_rejecting) : link_for_rejecting
      elsif model.accepted?
        link_for_canceling
      end
    end

    def link_for_accepting
      (link_to url_helpers.accept_admin_panel_appointment_path(model), class: 'btn btn-success btn-xs', method: :put do
        content_tag(:i, nil, class: 'fa fa-check') + 'Accept'
      end)
    end

    def link_for_rejecting
      (link_to url_helpers.reject_admin_panel_appointment_path(model), class: 'btn btn-danger btn-xs', method: :put do
        content_tag(:i, nil, class: 'fa fa-close') + 'Reject'
      end)
    end

    def link_for_canceling
      (link_to url_helpers.cancel_admin_panel_appointment_path(model), class: 'btn btn-danger btn-xs', method: :put do
        content_tag(:i, nil, class: 'fa fa-close') + 'Cancel'
      end)
    end
  end
end
