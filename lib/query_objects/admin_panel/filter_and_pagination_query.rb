module AdminPanel
  class FilterAndPaginationQuery
    INT_COLUMNS = %w[id vets_count status specialization_id pet_type_id experience].freeze
    BOOLEAN_COLUMNS = %w[is_active].freeze
    ADDITIONAL_PARAMS = { 'city' => { join_model: :location, field: 'locations.city' },
                          'specialization_id' => { join_model: :specializations, field: 'specializations.id' },
                          'pet_type_id' => { join_model: :pet_types, field: 'pet_types.id' } }.freeze

    def initialize(scope, params)
      @params = params

      self.scope = scope
    end

    def filter
      if draw_first?
        scope.order(id: :asc).page(params[:page]).per(10)
      else
        parse_params
        filter_by_search_params if @searchable_columns.present?
        filter_by_additional_params if @additional_params.present?
        filter_by_order_params
        filter_by_page_params
      end
    end

    private

    attr_accessor :scope
    attr_reader :params

    def draw_first?
      params[:draw] == '1'
    end

    def parse_params
      parse_search_params
      parse_additional_params
      parse_order_params
      parse_page_params
    end

    def parse_search_params
      @searchable_columns = []
      params[:columns].select { |_k, c| c[:search][:value].present? }.each_pair do |_k, c|
        column = {}
        column[:name] = c[:data]
        column[:value] = c[:search][:value]
        column[:type] = check_field_type(column[:name])
        @searchable_columns << column
      end
    end

    def check_field_type(name)
      if name.in?(INT_COLUMNS)
        :integer
      elsif name.in?(BOOLEAN_COLUMNS)
        :boolean
      else
        :string
      end
    end

    def parse_additional_params
      @additional_params = []
      ADDITIONAL_PARAMS.each_key do |param_name|
        next if params[param_name].blank?
        column = {}
        column[:name] = param_name
        column[:value] = params[param_name]
        column[:type] = check_field_type(param_name)
        @additional_params << column
      end
    end

    def parse_order_params
      order_params = params[:order].values.first
      order_column_num = order_params[:column]
      @order_column_dir = order_params[:dir].upcase
      @order_column_name = params[:columns].select { |k, _c| k == order_column_num }.values.first[:data]
    end

    def parse_page_params
      @page = (params[:start].to_i / params[:length].to_i) + 1
    end

    def filter_by_search_params
      @searchable_columns.each do |column|
        @scope = case column[:type]
                 when :integer
                   @scope.where("#{column[:name]} = :value", value: column[:value].to_i)
                 when :boolean
                   @scope.where("#{column[:name]} = :value", value: column[:value])
                 else
                   @scope.where("#{column[:name]} ILIKE :value", value: "%#{column[:value]}%")
                 end
      end
    end

    def filter_by_additional_params
      @additional_params.each do |column|
        column_data = ADDITIONAL_PARAMS[column[:name]]
        join_model = column_data[:join_model]
        field = column_data[:field]
        @scope = case column[:type]
                 when :integer
                   @scope.joins(join_model).where("#{field} = :value", value: column[:value].to_i)
                 else
                   @scope.joins(join_model).where("#{field} ILIKE :value", value: "%#{column[:value]}%")
                 end
      end
    end

    def filter_by_order_params
      @scope = scope.order("#{@order_column_name} #{@order_column_dir}")
    end

    def filter_by_page_params
      scope.page(@page).per(params[:length])
    end
  end
end
