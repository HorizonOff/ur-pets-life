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
                                         { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 6 } ] },
      'boardings': { 'url': '/admin_panel/boardings',
                     'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                  { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                  { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                  { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                  { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                  { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 5 },
                                  { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 6 } ] },
      'grooming_centres': { 'url': '/admin_panel/grooming_centres',
                            'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                         { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                         { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                         { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                         { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                         { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 5 },
                                         { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 6 } ] },
      'users': { 'url': '/admin_panel/users',
                 'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                              { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                              { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 2 },
                              { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 3 },
                              { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 4 },
                              { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 5 } ] },
      'contact_requests': { 'url': '/admin_panel/contact_requests', 'order_col': 5, 'order_dir': 'desc',
                            'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                         { 'searchable': false, 'orderable': false, 'data': 'user_name', 'targets': 1 },
                                         { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 2 },
                                         { 'searchable': false, 'orderable': false, 'data': 'user_mobile_number', 'targets': 3 },
                                         { 'searchable': false, 'orderable': false, 'data': 'subject', 'targets': 4 },
                                         { 'searchable': false, 'orderable': true, 'data': 'created_at', 'targets': 5 },
                                         { 'searchable': true, 'orderable': true, 'data': 'is_answered', 'targets': 6 },
                                         { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'admins': { 'url': '/admin_panel/admins',
                  'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                               { 'searchable': false, 'orderable': false, 'data': 'avatar', 'targets': 1 },
                               { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 2 },
                               { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                               { 'searchable': true, 'orderable': true, 'data': 'is_super_admin', 'targets': 4 },
                               { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 5 },
                               { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 6 } ] },
      'vets': { 'url': '/admin_panel/vets',
                'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                             { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                             { 'searchable': false, 'orderable': false, 'data': 'avatar', 'targets': 2 },
                             { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                             { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                             { 'searchable': true, 'orderable': true, 'data': 'experience', 'targets': 5 },
                             { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 6 },
                             { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'appointments': { 'url': '/admin_panel/appointments', 'order_col': 4, 'order_dir': 'desc',
                        'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                     { 'searchable': true, 'orderable': false, 'data': 'name', 'targets': 1 },
                                     { 'searchable': true, 'orderable': false, 'data': 'bookable_type', 'targets': 2 },
                                     { 'searchable': true, 'orderable': false, 'data': 'vet_name', 'targets': 3 },
                                     { 'searchable': true, 'orderable': true, 'data': 'created_at', 'targets': 4 },
                                     { 'searchable': true, 'orderable': true, 'data': 'start_at', 'targets': 5 },
                                     { 'searchable': true, 'orderable': true, 'data': 'status', 'targets': 6 },
                                     { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'posts': { 'url': '/admin_panel/posts',
                 'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                              { 'searchable': true, 'orderable': false, 'data': 'name', 'targets': 1 },
                              { 'searchable': true, 'orderable': false, 'data': 'title', 'targets': 2 },
                              { 'searchable': true, 'orderable': true, 'data': 'pet_type_id', 'targets': 3 },
                              { 'searchable': false, 'orderable': true, 'data': 'created_at', 'targets': 4 },
                              { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 5 } ] },
      'additional_services': { 'url': '/admin_panel/additional_services',
                               'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                            { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                            { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
                                            { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
                                            { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
                                            { 'searchable': false, 'orderable': false, 'data': 'website', 'targets': 5 },
                                            { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 6 },
                                            { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 } ] },
      'notifications': { 'url': '/admin_panel/notifications',
                         'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                      { 'searchable': true, 'orderable': false, 'data': 'name', 'targets': 1 },
                                      { 'searchable': true, 'orderable': true, 'data': 'skip_push_sending', 'targets': 2 },
                                      { 'searchable': false, 'orderable': true, 'data': 'created_at', 'targets': 3 },
                                      { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 4 } ] },
      'pets': { 'url': '/admin_panel/pets',
                'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                             { 'searchable': true, 'orderable': false, 'data': 'name', 'targets': 1 },
                             { 'searchable': false, 'orderable': false, 'data': 'avatar', 'targets': 2 },
                             { 'searchable': false, 'orderable': true, 'data': 'birthday', 'targets': 3 },
                             { 'searchable': true, 'orderable': true, 'data': 'pet_type_id', 'targets': 4 },
                             { 'searchable': true, 'orderable': true, 'data': 'sex', 'targets': 5 },
                             { 'searchable': false, 'orderable': false, 'data': 'weight', 'targets': 6 },
                             { 'searchable': true, 'orderable': false, 'data': 'status', 'targets': 7 },
                             { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 8 } ] },
      'specializations': { 'url': '/admin_panel/specializations',
                           'columns': [ { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
                                        { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
                                        { 'searchable': true, 'orderable': true, 'data': 'is_for_trainer', 'targets': 2 },
                                        { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 3 } ] }
    }
    var datatable = $('.datatable').first()
    if (datatable.hasClass('clinics')){
      init_datatable(table_rules['clinics']['url'], table_rules['clinics']['columns'])
    } else if (datatable.hasClass('trainers')){
      init_datatable(table_rules['trainers']['url'], table_rules['trainers']['columns'])
    } else if (datatable.hasClass('day_care_centres')) {
      init_datatable(table_rules['day_care_centres']['url'], table_rules['day_care_centres']['columns'])
    } else if (datatable.hasClass('grooming_centres')){
      init_datatable(table_rules['grooming_centres']['url'], table_rules['grooming_centres']['columns'])
    } else if (datatable.hasClass('users')){
      init_datatable(table_rules['users']['url'], table_rules['users']['columns'])
    } else if (datatable.hasClass('contact_requests')){
      init_datatable(table_rules['contact_requests']['url'], table_rules['contact_requests']['columns'], table_rules['contact_requests']['order_col'], table_rules['contact_requests']['order_dir'])
    } else if (datatable.hasClass('admins')){
      init_datatable(table_rules['admins']['url'], table_rules['admins']['columns'])
    } else if (datatable.hasClass('vets')){
      init_datatable(table_rules['vets']['url'], table_rules['vets']['columns'])
    } else if (datatable.hasClass('appointments')){
      init_datatable(table_rules['appointments']['url'], table_rules['appointments']['columns'], table_rules['appointments']['order_col'], table_rules['appointments']['order_dir'])
    } else if (datatable.hasClass('posts')){
      init_datatable(table_rules['posts']['url'], table_rules['posts']['columns'])
    } else if (datatable.hasClass('boardings')){
      init_datatable(table_rules['boardings']['url'], table_rules['boardings']['columns'])
    } else if (datatable.hasClass('additional_services')){
      init_datatable(table_rules['additional_services']['url'], table_rules['additional_services']['columns'])
    } else if (datatable.hasClass('notifications')){
      init_datatable(table_rules['notifications']['url'], table_rules['notifications']['columns'])
    } else if (datatable.hasClass('pets')){
      init_datatable(table_rules['pets']['url'], table_rules['pets']['columns'])
    } else {
      init_datatable(table_rules['specializations']['url'], table_rules['specializations']['columns'])
    }
  };
};

function init_datatable(url, column_rules, order_col, order_dir){
  if (typeof(order_col) == 'undefined') {
    var order_col = 0;
    var order_dir = 'asc'
  }
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
    "order": [[ order_col, order_dir ]],
    "columnDefs": column_rules,
    "drawCallback": function(settings) {
      $('.table a.check_response').on('ajax:success', draw_table)
    }
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
