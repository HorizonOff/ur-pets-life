module AdminPanel
  class TaxReportsController < AdminPanelController
    before_action :authorize_super_admin

    def index
      respond_to do |format|
        format.html {}
        format.xlsx { export_data }
      end
    end

    private

    def export_data
      @tax_reports = Order.order_status_flag_delivered.order(:delivery_at).includes(user: [:location])
      date_string = Time.now.strftime('%d-%M-%Y')
      if params[:from_date].present? && params[:to_date].present?
        @tax_reports = @tax_reports.created_in_range(params[:from_date].to_date.beginning_of_day,
                                                     params[:to_date].to_date.end_of_day)
        date_string = 'from' + params[:from_date].to_date.strftime('%d-%M-%Y') + 'to' +
                      params[:to_date].to_date.strftime('%d-%M-%Y')
      end
      name = "Tax_reports #{date_string}.xlsx"
      response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{name}"
    end
  end
end
