module AdminPanel
  class SpecializationDecorator < ApplicationDecorator
    decorates :specialization
    delegate_all

    def is_for_trainer
      model.is_for_trainer? ? 'Trainer' : 'Clinic / Vet'
    end

    def actions
      (link_to 'Edit', url_helpers.edit_admin_panel_specialization_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_specialization_path(model),
                 data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
                 class: 'btn btn-danger btn-xs check_response')
    end
  end
end
