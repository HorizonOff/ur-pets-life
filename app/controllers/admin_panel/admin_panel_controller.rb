module AdminPanel
  class AdminPanelController < ApplicationController
    include Pundit
    before_action :authenticate_admin!
    before_action :count_budges

    rescue_from Pundit::NotAuthorizedError, with: :not_allowed

    private

    def super_admin?
      current_admin.is_super_admin?
    end

    def authorize_super_admin
      authorize :application, :super_admin?
    end

    def pundit_user
      current_admin
    end

    def not_allowed
      respond_to do |format|
        format.html { redirect_to(admin_panel_root_path) && return }
        format.json { (render json: { message: 'You have no permission' }, status: 403) && return }
      end
    end

    def qualifications_params
      %i[id diploma university _destroy]
    end

    def location_params
      %i[latitude longitude city area street building_type building_name unit_number villa_number comment _destroy]
    end

    def schedule_params
      %i[day_and_night monday_open_at monday_close_at tuesday_open_at tuesday_close_at wednesday_open_at
         wednesday_close_at thursday_open_at thursday_close_at friday_open_at friday_close_at saturday_open_at
         saturday_close_at sunday_open_at sunday_close_at]
    end

    def service_option_params
      %i[id service_option_id price _destroy]
    end

    def picture_params
      %i[id attachment attachment_cache _destroy]
    end

    def count_budges
      if current_admin.is_super_admin?
        @new_contact_requests_count = ContactRequest.where(is_viewed: false).count
      else
        @new_appointments_count = current_admin.appointments.where(is_viewed: false).count
      end
    end
  end
end
