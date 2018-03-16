module AdminPanel
  class PetDecorator < ApplicationDecorator
    decorates :pet
    delegate_all

    def gender
      if pet.male?
        content_tag(:span, nil, class: 'fa fa-mars')
      else
        content_tag(:span, nil, class: 'fa fa-venus')
      end
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

    def actions
      pet_vaccinations_path + pet_diagnoses_path +
        (link_to 'Edit', url_helpers.edit_admin_panel_pet_path(model), class: 'btn btn-warning btn-xs') +
        (link_to 'Delete', url_helpers.admin_panel_pet_path(model),
                 method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs')
    end

    def pet_vaccinations_path
      link_to 'Vaccinations', url_helpers.vaccinations_admin_panel_pet_path(model), class: 'btn btn-info btn-xs'
    end

    def pet_diagnoses_path
      link_to 'Diagnoses', url_helpers.diagnoses_admin_panel_pet_path(model), class: 'btn btn-info btn-xs'
    end
  end
end
