module AdminPanel
class InvoicesController < AdminPanelController
  before_action :set_admin_panel_invoice, only: [:show, :edit, :update, :destroy]

  # GET /admin_panel/invoices
  # GET /admin_panel/invoices.json
  def index
    respond_to do |format|
      format.html {}
    end
  end

  # GET /admin_panel/invoices/1
  # GET /admin_panel/invoices/1.json
  def show
  end

  def download_invoices
    @pdfs_files_path = []
    to_date = Date.strptime(params[:anything][:to_date].to_s, '%d/%m/%Y')
    from_date = Date.strptime(params[:anything][:from_date].to_s, '%d/%m/%Y')
    formatted_to = to_date.strftime('%m/%d/%Y')
    formatted_from = from_date.strftime('%m/%d/%Y')
    @invorders = Order.includes({user: [:location]}, {order_items: [:item]}).where("created_at BETWEEN (?) AND (?)", formatted_from, formatted_to)
    respond_to do |format|
      format.pdf do
        zip_file_name = "Invoices_#{Time.now.utc.strftime('%d-%M-%Y')}.zip"
        @temp_zip_file = Tempfile.new zip_file_name
        begin
          generate_order_invoices
          generate_zip_for_invoices
          zip_data = File.read(@temp_zip_file.path)
          delete_temp_files
          send_data(zip_data, :type => 'application/zip', :filename => zip_file_name)
          #response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{zip_file_name}"
        ensure
          @temp_zip_file.close
          @temp_zip_file.unlink
        end
      end
    end
  end
  # GET /admin_panel/invoices/new
  def new
    @admin_panel_invoice = Order.new
  end

  # GET /admin_panel/invoices/1/edit
  def edit
  end

  # POST /admin_panel/invoices
  # POST /admin_panel/invoices.json
  def create
    @admin_panel_invoice = Order.new(admin_panel_invoice_params)

    respond_to do |format|
      if @admin_panel_invoice.save
        format.html { redirect_to @admin_panel_invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @admin_panel_invoice }
      else
        format.html { render :new }
        format.json { render json: @admin_panel_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_panel/invoices/1
  # PATCH/PUT /admin_panel/invoices/1.json
  def update
    respond_to do |format|
      if @admin_panel_invoice.update(admin_panel_invoice_params)
        format.html { redirect_to @admin_panel_invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_panel_invoice }
      else
        format.html { render :edit }
        format.json { render json: @admin_panel_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_panel/invoices/1
  # DELETE /admin_panel/invoices/1.json
  def destroy
    @admin_panel_invoice.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_panel_invoice
      @admin_panel_invoice = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_panel_invoice_params
      params.fetch(:admin_panel_invoice, {})
    end

    def generate_order_invoices

      @invorders.each do |invorder|
        @order = invorder
        @shippinglocation = Location.where(:id => @order.location_id).first
        @userAddress = (@shippinglocation.villa_number.blank? ? '' : (@shippinglocation.villa_number + ' '))  + (@shippinglocation.unit_number.blank? ? '' : (@shippinglocation.unit_number + ' ')) + (@shippinglocation.building_name.blank? ? '' : (@shippinglocation.building_name + ' ')) + (@shippinglocation.street.blank? ? '' : (@shippinglocation.street + ' ')) + (@shippinglocation.area.blank? ? '' : (@shippinglocation.area + ' ')) + (@shippinglocation.city.blank? ? '' : @shippinglocation.city)
        pdf = WickedPdf.new.pdf_from_string(render_to_string("admin_panel/invoices/show.html.erb", layout: "pdf.html.erb"))
        pdf_path = Rails.root.join('tmp', 'INV-' + @order.id.to_s + '.pdf')
        File.open(pdf_path, 'wb') do |file|
          file << pdf
        end
        @pdfs_files_path << pdf_path
      end

    end

    def generate_zip_for_invoices

      Zip::OutputStream.open(@temp_zip_file) { |zos| }
      Zip::File.open(@temp_zip_file.path, Zip::File::CREATE) do |zipfile|
       @pdfs_files_path.each do |pdf_path|
         zipfile.add pdf_path.to_s.split("/").last.to_s, pdf_path
       end
     end
    end

    def delete_temp_files
      @pdfs_files_path.each do |pdf_path|
        File.delete pdf_path
      end
    end
end
end
