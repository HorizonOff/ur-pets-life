// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require bootstrap.min
//= require custom
//= require icheck.min
//= require select2.full
//= require moment
//= require bootstrap-datetimepicker.min
//= require underscore
//= require gmaps/google
//= require cocoon
//= require fullcalendar
//= require daterangepicker
//= require ckeditor/init
//= require datatables
//= require dataTables.bootstrap.min
//= require dataTables.buttons.min
//= require buttons.bootstrap.min

//= require_self
//= require_tree .
$(document).on('turbolinks:load', function() {
  init_all_functions()
});

$(document).on('turbolinks:load', function() {
  init_datatables();
  init_icheck();
  init_timepicker();
  init_select2();
});
	
function init_icheck(){
  if ($("input.flat")[0]) {
    $('input.flat').iCheck({
      checkboxClass: 'icheckbox_flat-green',
      radioClass: 'iradio_flat-green'
    });
    $('input.flat.day_and_night').on('ifChecked', function(event){
      $('.timepicker').prop('disabled', true);
    });
    $('input.flat.day_and_night').on('ifUnchecked', function(event){
      $('.timepicker').prop('disabled', false);
    });
    $('input.flat#building_type').on('ifToggled', function(event){
      if ($(this).val() == 'building') {
        show_and_enable_inputs($('div.building'))
        hide_and_disable_inputs($('div.villa'))
      } else {
        show_and_enable_inputs($('div.villa'))
        hide_and_disable_inputs($('div.building'))
      }
    });
    $('input.flat[name*="use_clinic_location"]').on('ifChecked', function(){
      use_clinic_location = true;
      disable_inputs($('.location_tab_fields'));
      check_clinic_location();
    });
    $('input.flat[name*="use_clinic_location"]').on('ifUnchecked', function(){
      use_clinic_location = false;
      enable_inputs($('.location_tab_fields'));
    });
  }
}

function show_and_enable_inputs(element) {
  element.show()
  element.find('input:disabled').prop('disabled', false);
}

function hide_and_disable_inputs(element) {
  element.hide()
  element.find('input:enabled').prop('disabled', true);
}

function init_select2(){
  if ($('.select2')[0]) {
    $('.select2').select2({
      placeholder: 'Select ...',
      allowClear: true,
      width: '100%'
    });
    $('.select2.clinics_select').on('select2:select select2:unselect', check_clinic_location);
  }
}

function init_timepicker(){
  if ($('.single_cal1')){
    $('.single_cal1').daterangepicker({
      singleDatePicker: true,
      singleClasses: "picker_1",
      autoUpdateInput: false,
      locale: {
        "format": "DD/MM/YYYY"
      }
    });

    $('.single_cal1').on('apply.daterangepicker', function(ev, picker) {
      var new_date = picker.startDate.format('DD/MM/YYYY')
      var vet_id = $(this).data('vet-id');
      $(this).val(new_date);
      $.ajax({
        type: 'get',
        url: '/admin_panel/vets/' + vet_id + '/schedule?date=' + new_date,
        success: function(response){
          $('.select2').empty();
          $('.select2').select2({
            placeholder: 'Select ...',
            allowClear: true,
            data: response.time_slots
          });
        }
      });
    });
  };

  if ($('.timepicker')[0]) {
    $('.timepicker.open').datetimepicker({
      format: 'hh:mm A'
    })
    $('.timepicker.close_time').datetimepicker({
      format: 'hh:mm A',
      useCurrent: false
    })

    $('.timepicker').on('dp.change', function(e) {
      var element = $(e.target);
      var related_element = element.parent().siblings('div').find('.timepicker');
      if (element.hasClass('open')){
        related_element.data("DateTimePicker").minDate(e.date);
      } else {
        related_element.data("DateTimePicker").maxDate(e.date);
      }
    });
  }
}

function init_datatables(){
  if ($('.datatable')){
    var table = $('.datatable').DataTable({
      "orderCellsTop": true,
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": "/admin_panel/clinics",
        "data": function(d){
          d.specialization_id = $(".additional_parameter[name*='specialization_id']").val();
          d.pet_type_id = $(".additional_parameter[name*='pet_type_id']").val();
          d.city = $(".additional_parameter[name*='city']").val();
        }
      },
      'order': [[ 0, 'asc' ]],
      "columnDefs": [
        { 'searchable': true, 'orderable': true, 'data': 'id', 'targets': 0 },
        { 'searchable': true, 'orderable': true, 'data': 'name', 'targets': 1 },
        { 'searchable': false, 'orderable': false, 'data': 'picture', 'targets': 2 },
        { 'searchable': true, 'orderable': true, 'data': 'email', 'targets': 3 },
        { 'searchable': false, 'orderable': false, 'data': 'mobile_number', 'targets': 4 },
        { 'searchable': true, 'orderable': true, 'data': 'vets_count', 'targets': 5 },
        { 'searchable': true, 'orderable': true, 'data': 'is_active', 'targets': 6 },
        { 'searchable': false, 'orderable': false, 'data': 'actions', 'targets': 7 }
      ]
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
  };
};

$(document).on('change', 'input.service_detail_switch', function() {
  var destroy_checkbox = $(this).siblings('.destroy_service_detail')
  destroy_checkbox.prop('checked', !destroy_checkbox.prop('checked'))
  var selector = $(this).parent('.control-label').siblings('.service_details_fields');
  if (selector.css('display') == 'none') {
    show_and_enable_inputs(selector)
  } else {
    hide_and_disable_inputs(selector)
  }
});
