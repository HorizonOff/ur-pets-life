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
//= require datatables
//= require dataTables.bootstrap.min
//= require dataTables.buttons.min
//= require buttons.bootstrap.min
//= require location.js
//= require datatable.js
//= require toastr
//= require cable

//= require_self

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
      $('.working_hours .timepicker').prop('disabled', true);
    });
    $('input.flat.day_and_night').on('ifUnchecked', function(event){
      $('.working_hours .timepicker').prop('disabled', false);
    });
    $('input.flat.optional_checkbox').on('ifChecked', function(event){
      hide_and_disable_inputs($('.user_ids'))
      $('.optional_select').prop('disabled', true);
    });
    $('input.flat.optional_checkbox').on('ifUnchecked', function(event){
      show_and_enable_inputs($('.user_ids'))
      $('.optional_select').prop('disabled', false);
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
    $(document).on("ifChecked", "input.user_type", function() {
      if ($(this).val() != 'new_user') {
          $('div.new_user').removeClass('hiden');
          enable_inputs($('div.new_user'));
          $('div.registered_user').addClass('hiden');
          disable_inputs($('div.registered_user'));
      } else {
          $('div.registered_user').removeClass('hiden');
          enable_inputs($('div.registered_user'));
          $('div.new_user').addClass('hiden');
          disable_inputs($('div.new_user'));
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

$.each([ '#items' ], function( index, value ){
    $(document).on('cocoon:after-insert', value, function(e, added_element) {
        added_element.find('.select2').select2({
            placeholder: 'Select ...',
            allowClear: true,
            width: '100%'
        });
    });
});

$(document).on('cocoon:after-insert', '#service_option_times', function(e, added_element) {
  init_timepicker();
});

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

  if ($('.single_cal2')){
    $('.single_cal2').daterangepicker({
      singleDatePicker: true,
      singleClasses: "picker_1",
      autoUpdateInput: false,
      locale: {
        "format": "DD/MM/YYYY"
      }
    }, function(chosen_date) {
        $(this.element[0]).val(chosen_date.format("DD/MM/YYYY"));
    });
  }

  if ($('.month_picker')){
    $('.month_picker').datetimepicker({
      format: "MMMM YYYY",
      viewMode: 'months'
    });
  };

  if ($('.timepicker')[0]) {
    $('.timepicker.open').datetimepicker({
      format: 'hh:mm A'
    })
    $('.timepicker.close_time').datetimepicker({
      format: 'hh:mm A'
      // useCurrent: false
    })

    // $('.timepicker').on('dp.change', function(e) {
    //   var element = $(e.target);
    //   var related_element = element.parent().siblings('div').find('.timepicker');
    //   if (element.hasClass('open')){
    //     related_element.data("DateTimePicker").minDate(e.date);
    //   } else {
    //     related_element.data("DateTimePicker").maxDate(e.date);
    //   }
    // });
  }
}

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

$(document).on('ifChanged', 'input.service_option_switch', function() {
  var destroy_checkbox = $(this).parent().siblings('._destroy')
  destroy_checkbox.prop('checked', !destroy_checkbox.prop('checked'))
  var service_option_id_field = $(this).parents('.check_boxes').find('.service_option_id');
  var selector = $(this).parents('.check_boxes').siblings('.service_option_details_fields');
  var times_selector = $(this).parents('.check_boxes').parent().siblings('.service_option_times_fields');
  if(selector.hasClass('hiden')) {
    selector.removeClass('hiden');
    times_selector.removeClass('hiden');
    show_and_enable_inputs(selector);
    service_option_id_field.prop('disabled', false);
  } else {
    selector.addClass('hiden');
    times_selector.addClass('hiden');
    hide_and_disable_inputs(selector);
    service_option_id_field.prop('disabled', true);
  }
});

$(document).on('click', '.photo_preview', function() {
  html_text = '<img src="' + $(this).data('url') + '" alt="photo preview" style="max-width:100%;">'
  $('.modal-body').html(html_text)
  $('#photo_preview').modal('show');
});

$(document).on('click', '.close-chat-js', function() {
  var chat_id = $('#messages').data('support-chat-id');
  $.ajax({
    type: 'get',
    url: '/admin_panel/support_chats/' + chat_id + '/close',
    success: function(response){
      $('#chat-form').addClass('display-none');
    }
  });
});

// $( document ).on('turbolinks:load', function() {
//   $('#new_chat_message').ajaxSend(function() {
//     debugger
//     $(this).find('input[type="text"]').val('');
//     $(this).find('input[type="file"]').val('');
//   });
// });

$(document).on("change", ".changed_subtotal", function(){
    var result = 0;
    var admin_discount = $('#order_admin_discount').val();
    var redeem_points = $('#order_RedeemPoints').val();
    var user_id = $('#user_id').val();
    var order_items = [];

    $('.order_item').each(function () {
        var order_id = $(this).find('.item_id').val();
        var quantity = $(this).find('.quantity').val();
        order_items.push({order_id: order_id, quantity: quantity});
    });

    $.ajax({
        type: 'get',
        url: '/admin_panel/calculating_price',
        data: { item: { admin_discount: admin_discount, RedeemPoints: redeem_points, user_id: user_id, order_items: [ order_items ] }}
    }).done(function (data) {
        $('.subtotal_price')[0].innerHTML = data['subtotal'];
        $('.total_price')[0].innerHTML = data['total'];
    }).fail(function (jqXHR, ajaxOptions, thrownError) {
        console.log('server not responding...');
    });
});
