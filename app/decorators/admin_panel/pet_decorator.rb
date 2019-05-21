module AdminPanel
  class PetDecorator < ApplicationDecorator
    decorates :pet
    delegate_all

    def name
      model.name || model.description
    end

    def avatar
      content_tag(:image, '', src: model.avatar.thumb.url, class: 'avatar') if model.avatar?
    end

    def gender
      if pet.male?
        content_tag(:span, nil, class: 'fa fa-mars')
      elsif pet.female?
        content_tag(:span, nil, class: 'fa fa-venus')
      end
    end

    def birthday
      model.birthday&.strftime('%e %b %Y')
    end

    def pet_type
      model.pet_type.name
    end

    def status
      if pet.lost?
        content_tag(:span, 'LOST', class: 'label label-danger')
      elsif pet.is_for_adoption?
        content_tag(:span, 'FOR ADOPTION', class: 'label label-success')
      elsif pet.found?
        content_tag(:span, 'FOUND', class: 'label label-warning')
      end
    end

    def status_text
      if pet.lost?
        'LOST'
      elsif pet.is_for_adoption?
        'FOR ADOPTION'
      elsif pet.found?
        'FOUND'
      end
    end

    def actions
      pet_vaccinations_path + pet_diagnoses_path + crud_actions
    end

    def pet_vaccinations_path
      link_to 'Vaccinations', url_helpers.vaccinations_admin_panel_pet_path(model), class: 'btn btn-info btn-xs'
    end

    def pet_diagnoses_path
      link_to 'Diagnoses', url_helpers.diagnoses_admin_panel_pet_path(model), class: 'btn btn-info btn-xs'
    end

    def crud_actions
      (link_to 'Show', url_helpers.admin_panel_pet_path(model), class: 'btn btn-primary btn-xs') +
        (link_to 'Edit', url_helpers.edit_admin_panel_pet_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_pet_path(model),
                 data: { confirm: 'Are you sure?' }, method: :delete, remote: true,
                 class: 'btn btn-danger btn-xs check_response')
    end
  end
end
