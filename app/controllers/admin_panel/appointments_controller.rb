module AdminPanel
  class AppointmentsController < AdminPanelController
    before_action :set_appointment, except: :index
    before_action :can_manage?, except: :index
    before_action :view_appointment, except: %i[index update_duration]

    def index
      respond_to do |format|
        format.html {}
        format.xlsx { export_data }
        format.json { filter_appointments }
      end
    end

    def show; end

    def accept
      @appointment.update(status: :accepted) if @appointment.can_be_accepted?
      render :show
    end

    def reject
      @appointment.update(status: :rejected) if @appointment.can_be_rejected?
      render :show
    end

    def cancel
      @appointment.update(status: :canceled)
      render :show
    end

    def update_duration
      if @appointment.update_columns(end_at: Time.zone.parse(params[:end_at]))
        render json: { message: 'Appointment duration successfully updated' }
      else
        render json: { errors: @appointment.errors.full_messages }, status: 422
      end
    end

    private

    def set_appointment
      @appointment = Appointment.find_by(id: params[:id])
    end

    def can_manage?
      authorize @appointment, :can_manage?
    end

    def filter_appointments
      filtered_appointments = filter_and_pagination_query.filter
      appointments = ::AdminPanel::AppointmentDecorator.decorate_collection(filtered_appointments)
      serialized_appointments = ActiveModel::Serializer::CollectionSerializer.new(
        appointments, serializer: ::AdminPanel::AppointmentFilterSerializer, adapter: :attributes
      )
      render json: { draw: params[:draw], recordsTotal: Appointment.count,
                     recordsFiltered: filtered_appointments.total_count, data: serialized_appointments }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('Appointment', params, current_admin)
    end

    def view_appointment
      return if current_admin.is_super_admin?
      @appointment.update_attribute(:is_viewed, true)
    end

    def export_data
      @appointments = policy_scope(Appointment).order(:id)
                                               .includes(:user, :bookable, :vet, :service_option_times,
                                                         service_option_times: [:service_option_detail,
                                                                                service_option_detail: :service_option])
      name = "appointments #{Time.now.utc.strftime('%d-%M-%Y')}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end
