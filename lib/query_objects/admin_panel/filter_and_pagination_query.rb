module AdminPanel
  class FilterAndPaginationQuery
    INT_COLUMNS = %w[id vets_count status specialization_id pet_type_id experience].freeze
    BOOLEAN_COLUMNS = %w[is_active is_answered is_super_admin].freeze
    ADDITIONAL_PARAMS = { 'city' => { join_model: :location, field: 'locations.city' },
                          'specialization_id' => { join_model: :specializations, field: 'specializations.id' },
                          'pet_type_id' => { join_model: :pet_types, field: 'pet_types.id' } }.freeze
    SQL_RULES = { 'name' => { models: %w[User Appointment Post],
                              sql: "(users.first_name || ' ' || users.last_name) ILIKE :value" },
                  'vet_name' => { models: %w[Appointment], join_model: :vet,
                                  sql: '(vets.name ILIKE :value)' } }.freeze

    def initialize(model, params, admin = nil)
      @model = model
      @params = params
      @admin = admin

      self.scope = admin ? (model + 'Policy::Scope').constantize.new(admin, model).resolve : model.constantize.all
    end

    def filter
      select_additional_fields
      if draw_first?
        scope.order(id: :asc).page(params[:page]).per(10)
      else
        parse_params
        filter_by_all_params
      end
    end

    private

    attr_reader :model, :params
    attr_accessor :scope

    def select_additional_fields
      if model == 'User'
        @scope = scope.select("users.*, concat(users.first_name, ' ', users.last_name) as name")
      elsif model == 'Appointment'
        @scope = scope.includes(:vet, :user).joins(:user)
      elsif model == 'Post'
        @scope = scope.includes(:user).joins(:user)
      end
    end

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

    def filter_by_all_params
      filter_by_search_params if @searchable_columns.present?
      filter_by_additional_params if @additional_params.present?
      filter_by_order_params
      filter_by_page_params
    end

    def filter_by_search_params
      @searchable_columns.each do |column|
        @scope = choose_sql(column)
      end
    end

    def choose_sql(column)
      column_name = column[:name]
      field = model.downcase.pluralize + '.' + column_name
      column_type = column[:type]
      column_value = column[:value]

      if specific_sql_rule_for?(column_name)
        use_sql_rule(column)
      elsif column_type == :integer
        @scope.where("#{field} = :value", value: column_value.to_i)
      elsif column_type == :boolean
        @scope.where("#{field} = :value", value: column_value)
      else
        @scope.where("#{field} ILIKE :value", value: "%#{column_value}%")
      end
    end

    def specific_sql_rule_for?(column_name)
      SQL_RULES[column_name] && SQL_RULES[column_name][:models].include?(model)
    end

    def use_sql_rule(column)
      column_rule = SQL_RULES[column[:name]]
      column_value = column[:value]
      if column_rule[:join_model]
        @scope.joins(column_rule[:join_model])
              .where(column_rule[:sql], value: "%#{column_value}%")
      else
        @scope.where(column_rule[:sql], value: "%#{column_value}%")
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
      field = model == 'User' ? @order_column_name : model.downcase.pluralize + '.' + @order_column_name
      @scope = scope.distinct.order("#{field} #{@order_column_dir}")
    end

    def filter_by_page_params
      scope.page(@page).per(params[:length])
    end
  end
end
