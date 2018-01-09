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

//= require_self
//= require_tree .
$(document).on('turbolinks:load', function() {
  init_all_functions()
});

$(document).on('turbolinks:load', function() {
  init_icheck();
  init_select2();
  init_timepicker();
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
    $('.select2.clinics_select').on('select2:select', check_clinic_location)
    $('.select2.clinics_select').on('select2:unselect', clear_clinic_location);
  }
}

function init_timepicker(){
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
