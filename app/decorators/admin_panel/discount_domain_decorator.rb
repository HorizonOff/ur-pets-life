module AdminPanel
  class DiscountDomainDecorator < ApplicationDecorator
    decorates :discount_domain
    delegate_all

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def actions
      (link_to 'Edit', url_helpers.edit_admin_panel_discount_domain_path(model), class: 'btn btn-warning btn-xs') +
      (link_to 'Delete', url_helpers.admin_panel_discount_domain_path(model),
               data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
               class: 'btn btn-danger btn-xs check_response')
    end
  end
end
