function init_datatables(){
  if ($('.datatable')){
    var table_rules = {
      'clinics': { 'url': '/admin_panel/clinics',
                   'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                { 'searchable': true, 'orderable': true, 'data': 'vets_count', 'targets': 5 },
                                { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 6 },
                                { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'trainers': { 'url': '/admin_panel/trainers',
                    'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                 { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                 { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                 { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                 { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                 { 'searchable': true, 'orderable': true, 'data': 'experience', 'targets': 5 },
                                 { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 6 },
                                 { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'day_care_centres': { 'url': '/admin_panel/day_care_centres',
                            'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                         { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                         { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                         { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                         { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                         { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 5 },
                                         { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 6 } ] }
    }
    var datatable = $('.datatable').first()
    if (datatable.hasClass('clinics')){
      init_datatable(table_rules['clinics']['url'], table_rules['clinics']['columns'])
    } else if (datatable.hasClass('trainers')){
      init_datatable(table_rules['trainers']['url'], table_rules['trainers']['columns'])
    } else {
      init_datatable(table_rules['day_care_centres']['url'], table_rules['day_care_centres']['columns'])
    }
  };
};

function init_datatable(url, column_rules){
  var table = $('.datatable').DataTable({
    "orderCellsTop": true,
    "processing": true,
    "serverSide": true,
    "ajax": {
      "url": url,
      "data": function(d){
        d.specialization_id = $(".additional_parameter[name*='specialization_id']").val();
        d.pet_type_id = $(".additional_parameter[name*='pet_type_id']").val();
        d.city = $(".additional_parameter[name*='city']").val();
      }
    },
    'order': [[ 0, 'asc' ]],
    "columnDefs": column_rules
  });

  $('.additional_parameter.select2').on('select2:select select2:unselect', draw_table)
  $('input.additional_parameter').on('change', draw_table)

  $('.datatable thead .select2').on('select2:select select2:unselect', filter_again)
  $('.datatable thead input').on('keyup change', filter_again)
  
  function draw_table(){
    setTimeout(function(){
      table.draw();
    }, 200)
  }

  function filter_again(){
    var input = this
    setTimeout(function(){
      var column_index = $(input).parent().index();
      if (table.column(column_index).search() !== input.value){
        table.column(column_index).search(input.value).draw();
      };
    }, 200)
  }
}
