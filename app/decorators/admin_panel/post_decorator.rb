module AdminPanel
  class PostDecorator < ApplicationDecorator
    decorates :post
    delegate_all

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end

    def pet_type_name
      pet_type.name
    end

    def actions
      link_to 'Show', url_helpers.admin_panel_post_path(model), class: 'btn btn-primary btn-xs'
    end
  end
end
