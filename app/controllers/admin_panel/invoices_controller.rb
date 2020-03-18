module AdminPanel
class InvoicesController < AdminPanelController
  before_action :set_admin_panel_invoice, only: [:show, :edit, :update, :destroy]
  before_action :authorize_super_admin_employee, only: :index
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
    DownloadInvoicesWorker.perform_async(params[:from_date], params[:to_date])
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
end
end
